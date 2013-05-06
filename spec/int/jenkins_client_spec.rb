require File.join(File.dirname(__FILE__), '../spec_helper')
require 'jenkins_client'

describe "Jenkins client" do
  before(:each) do
    @client = JenkinsClient.new('http://jenkins.sqlalchemy.org')
  end

  it "should fetch commit data for a build" do
    commits = @client.commits("sqlalchemy-rel_07-sqlite-2.4", 67)
    commits.should have(1).items
  end

  it "should fetch coverage data for a build" do
    coverage_change = @client.coverage("sqlalchemy-rel_07-sqlite-2.4", 67)

    coverage_change.line.should be_within(0.01).of(0.01)
    coverage_change.conditional.should be_within(0.01).of(0.01)
  end
end