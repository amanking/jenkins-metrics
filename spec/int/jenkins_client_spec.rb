require File.join(File.dirname(__FILE__), '../spec_helper')
require 'jenkins_client'

describe "Jenkins client" , :broken => false do
  before(:each) do
    @client = JenkinsClient.new('http://localhost:8080')
  end

  xit "should fetch coverage data change " do
    coverage_change = @client.latest_build_info("my-job")

    coverage_change.commits.should have(1).items

    first_commit = coverage_change.commits.first
    first_commit.author.should start_with("Smita")
    first_commit.id.should == 1964

    coverage_change.conditional.should be_within(0.01).of(0.01)
    coverage_change.conditional.should be_within(0.01).of(0.01)
  end

  it "should fetch build info" do
    build_info = @client.latest_build_info("WebStubCoverage")

    build_info.commits.should have(1).items
    build_info.build_number.should == 12
    build_info.project_name.should == "WebStub"

    first_commit = build_info.commits.first
    first_commit.author.should start_with("arjunk")

    build_info.coverage_change.conditional.should be_within(0.01).of(-14.51)
    build_info.coverage_change.line.should be_within(0.01).of(-12.90)
  end

end