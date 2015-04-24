module LatexLogParser
  class LineRewrapper
    attr_reader :wrapped_lines

    REWRAP_LENGTH = 79
    def initialize(lines)
      @split_lines = lines.split("\n")
      @current_line = @split_lines.first
      @wrapped_lines = []
    end

    def rewrap
      @split_lines.each_cons(2) do |last_line, line|
        process_line(last_line, line)
      end
      @wrapped_lines << @current_line

      yield @wrapped_lines
    end

    def process_line(last_line, line)
      if wrapped? last_line
        @current_line += line
      else
        @wrapped_lines << @current_line
        @current_line = line
      end
    end

    def wrapped?(last_line)
      last_line.length == REWRAP_LENGTH
    end
  end
end
