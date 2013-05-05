require File.join(File.dirname(__FILE__), '../spec_helper')
require 'jenkins_client'

describe "Jenkins client" do
  before(:all) do
    @client = JenkinsClient.new('https://builds.apache.org/job')
  end

  it "should fetch commit data for a build" do
    commits = @client.commits("commons-collections", 204)
    commits.should have(34).items
  end

  xit "should fetch coverage data for a build" do
    coverage_change = @client.coverage("", 2)
    coverage_change.line.should be_within(0.01).of(9.01)
    coverage_change.conditional.should be_within(0.01).of(1.12)
  end
end