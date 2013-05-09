require 'net/https'
require 'uri'
require 'json'
require 'model/commit'
require 'model/coverage_change'
require 'model/build_info'

class JenkinsClient
  def initialize(base_url)
    @base = base_url
  end

  def latest_build_info(job_name)
    last_build = get_json(last_build_url(job_name))

    first_cause = last_build["actions"].first["causes"].first
    build_number, project_name = first_cause["upstreamBuild"], first_cause["upstreamProject"]

    coverage_change = coverage_change(job_name, last_build["number"])
    BuildInfo.new(build_number, project_name, commits(last_build), coverage_change)
  end

  private

  def coverage_change(job_name, coverage_build_number)
    current_coverage = get_json(coverage_info_url(job_name, coverage_build_number))
    previous_coverage = get_json(coverage_info_url(job_name, coverage_build_number - 1))

    line_change = coverage_ratio(current_coverage, 'Lines') - coverage_ratio(previous_coverage, 'Lines')
    conditional_change = coverage_ratio(current_coverage, 'Conditionals') - coverage_ratio(previous_coverage, 'Conditionals')

    CoverageChange.new(line_change, conditional_change)
  end

  def get_json(data_url)
    uri = URI.parse(data_url)
    request = Net::HTTP::Get.new(uri.request_uri)

    http = Net::HTTP.new(uri.host, uri.port)

    if (data_url.start_with? 'https')
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    JSON.parse(http.request(request).body)
  end

  def commits(build_data)
    build_data['changeSet']['items'].map do |item|
      Commit.new({
                     :author => item['author']['fullName'],
                     :message => item['msg'],
                     :id => item['rev'],
                     :files => item['affectedPaths']
                 })
    end
  end

  def coverage_info_url(job_name, build_number)
    "#{job_url(job_name)}/#{build_number}/cobertura/api/json?depth=2"
  end

  def last_build_url(job_name)
    "#{job_url(job_name)}/lastBuild/api/json"
  end

  def job_url(job_name)
    "#{@base}/job/#{job_name}"
  end

  def coverage_ratio(coverage_data, coverage_item)
    coverage_data['results']['elements'].find { |element| element['name'].eql? coverage_item }['ratio']
  end
end


