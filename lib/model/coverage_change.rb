class CoverageChange


  attr_reader :line, :conditional, :commits

  def initialize(line_change, conditional_change, commits=[])
    @line = line_change
    @conditional = conditional_change
    @commits = commits
  end

  @@EMPTY = CoverageChange.new(0, 0)

end