class BuildInfo
  attr_reader :build_number, :project_name, :commits, :coverage_change

  def initialize(build_number,project_name,commits,coverage_change)
    @commits = commits
    @build_number = build_number
    @project_name = project_name
    @coverage_change = coverage_change
  end


  def has_changeset?
    !commits.empty?
  end

end