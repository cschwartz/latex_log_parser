module LatexLogParser
  class Error < Line
    attr_reader :message, :line_number

    BODY_REGEX = /!\ (?<type>.*?)\n
      l\.(?<line_number>\d+)(?<line>.*?)\n
      (?<second_line>.*?)\n
      (?<details>.*)/x

    def self.instance_for_line(line, lines)
      Error.new(line, lines) if line.start_with? '!'
    end

    def process(parser)
      process_content do |content|
        match_content content do |match|
          @message = match[:type]
          @line_number = match[:line_number].to_i
        end

        parser.add_error self
      end
    end

    def process_content
      content = @trigger
      content += "\n#{@next_lines.shift }"
      content += "\n#{@next_lines.shift }"
      content += "\n#{ @next_lines.shift }" until @next_lines.first.empty?
      yield content
    end

    def match_content(content)
      match = BODY_REGEX.match(content)

      if match
        yield match
      else
        Logger.info("Unknown error format: #{ content }")
      end
    end
  end
end
