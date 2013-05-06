class CoverageChange
  attr_reader :line, :conditional

  def initialize(line_change, conditional_change)
    @line = line_change
    @conditional = conditional_change
  end
end