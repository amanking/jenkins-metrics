class CoverageChange

  @@EMPTY = CoverageChange.new(0, 0)

  attr_reader :line, :conditional, :commits

  def initialize(line_change, conditional_change, commits=[])
    @line = line_change
    @conditional = conditional_change
    @commits = commits
  end
end