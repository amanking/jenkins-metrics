class CoverageChange

  attr_reader :line, :conditional, :commits

  def initialize(line_change, conditional_change, commits=[])
    @line = line_change
    @conditional = conditional_change
    @commits = commits
  end

  def changed?
    !commits.empty?
  end

  def to_s
    <<-STR
      line : #{@line}
      conditional : #{@conditional}
      commits : #{@commits}
    STR
  end

  EMPTY = CoverageChange.new(0, 0)
end