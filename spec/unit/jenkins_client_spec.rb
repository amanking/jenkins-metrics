require File.join(File.dirname(__FILE__), "../spec_helper")
require 'jenkins_client'

describe "Jenkins client" do

  it "should fetch build related data" do
    client = JenkinsClient.new('https://builds.apache.org/job/commons-collections/')
    commits = client.commits(204)

    commits.each { |commit|
      p commit
    }

    commits.should have(34).items
  end
end