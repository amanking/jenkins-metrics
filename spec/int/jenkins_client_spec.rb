require File.join(File.dirname(__FILE__), '../spec_helper')
require 'jenkins_client'

describe "Jenkins client" , :broken => true do
  before(:each) do
    @client = JenkinsClient.new('http://localhost:9099/jenkins')
  end

  it "should fetch coverage data change " do
    coverage_change = @client.latest_coverage_change("my-job")

    coverage_change.commits.should have(1).items

    first_commit = coverage_change.commits.first
    first_commit.author.should start_with("Smita")
    first_commit.id.should == 1964

    coverage_change.conditional.should be_within(0.01).of(0.01)
    coverage_change.conditional.should be_within(0.01).of(0.01)
  end
end