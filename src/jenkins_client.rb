require 'net/https'
require 'uri'
require 'json'
require File.join(File.dirname(__FILE__), 'commit')

class JenkinsClient
  def initialize(base_url)
    @base = base_url
  end

  def commits(build_number)
    build_data = JSON.parse(fetch_data(build_number))
    commits = build_data["changeSet"]["items"].map { |item| create_commit(item) }
    commits
  end

  private

  def fetch_data(build_number)
    uri = URI.parse("#{@base}/#{build_number}/api/json")
    request = Net::HTTP::Get.new(uri.request_uri)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
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


