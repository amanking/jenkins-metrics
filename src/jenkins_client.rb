require 'net/https'
require 'uri'
require 'json'
require File.join(File.dirname(__FILE__), 'commit')
require File.join(File.dirname(__FILE__), 'coverage_change')

class JenkinsClient
  def initialize(base_url)
    @base = base_url
  end

  def commits(job_name, build_number)
    build_data = get_json(build_info_url(job_name, build_number))

    build_data['changeSet']['items'].map do |item|
      Commit.new({
                     :by => item['author']['fullName'],
                     :message => item['msg'],
                     :id => item['commitId'],
                     :files => item['affectedPaths']
                 })
    end
  end

  def coverage(job_name, build_number)
    current_coverage = get_json(coverage_info_url(job_name, build_number))
    previous_coverage = get_json(coverage_info_url(job_name, build_number - 1))

    line_change = coverage(current_coverage, 'Lines') - coverage(previous_coverage, 'Lines')
    conditional_change = coverage(current_coverage, 'Conditionals') - coverage(previous_coverage, 'Conditionals')

    CoverageChange.new(line_change, conditional_change)
  end

  private

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

  def build_info_url(job_name, build_number)
    "#{jenkins_url(job_name, build_number)}/api/json"
  end

  def coverage_info_url(build_number, job_name)
    "#{jenkins_url(job_name, build_number)}/cobertura/api/json?depth=4"
  end

  def jenkins_url(job_name, build_number)
    "#{@base}/#{job_name}/#{build_number}"
  end

  def coverage(coverage_data, coverage_item)
    coverage_data['results']['elements'].find { |element| element['name'].eql? coverage_item } ['ratio']
  end
end


