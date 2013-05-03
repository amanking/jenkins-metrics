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
    build_data = JSON.parse(fetch_data("#{job_build_url(job_name, build_number)}/api/json"))
    commits = build_data["changeSet"]["items"].map { |item| create_commit(item) }
    commits
  end

  def coverage(job_name, build_number)
    new_coverage_data = JSON.parse(fetch_data("#{job_build_url(job_name, build_number)}/cobertura/api/json?depth=4"))
    old_coverage_data = JSON.parse(fetch_data("#{job_build_url(job_name, build_number - 1)}/cobertura/api/json?depth=4"))

    line_change = line_coverage(new_coverage_data) - line_coverage(old_coverage_data)
    conditional_change = conditional_coverage(new_coverage_data) - conditional_coverage(old_coverage_data)

    CoverageChange.new(line_change, conditional_change)
  end

  private

  def line_coverage(coverage_data)
    coverage_data['results']['elements'].find {|element| element["name"].eql? "Lines"} ["ratio"]
  end

  def conditional_coverage(coverage_data)
    coverage_data['results']['elements'].find {|element| element["name"].eql? "Conditionals"} ["ratio"]
  end

  def job_build_url(job_name, build_number)
    "#{@base}/#{job_name}/#{build_number}"
  end

  def fetch_data(data_url)
    uri = URI.parse(data_url)
    request = Net::HTTP::Get.new(uri.request_uri)

    http = Net::HTTP.new(uri.host, uri.port)

    if(data_url.start_with? "https")
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    http.request(request).body
  end

  def create_commit(item)
    Commit.new({
                   :by => item['author']['fullName'],
                   :message => item['msg'],
                   :id => item['commitId'],
                   :files => item['affectedPaths']
               })
  end
end


