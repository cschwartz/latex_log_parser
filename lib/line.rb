module LatexLogParser
  class Line
    def initialize(trigger, next_lines)
      @trigger = trigger
      @next_lines = next_lines
    end

    def process(_parser)
    end
  end

  class Ignore < Line
    def self.instance_for_line(line, lines)
      Ignore.new(line, lines)
    end
  end
end
