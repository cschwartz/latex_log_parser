module LatexLogParser
  class Warning < Line
    attr_reader :package, :details
    BODY_REGEX = /(?<header>Package\ (?<package>.*?)\ Warning: )
      (?<details>(.*\n)*)/x
    HEADER_REGEX = /(?<header>Package\ (?<package>.*?)\ Warning: )/

    def self.instance_for_line(line, lines)
      Warning.new(line, lines) if HEADER_REGEX =~ line
    end

    def process(parser)
      process_content do |content|
        match_content content do |match|
          @package = match[:package]
          @details = match[:details]
            .gsub(/\(#{ match[:package] }\)\s*/, '')
            .gsub(/\n/, ' ')
            .strip
        end

        parser.add_warning self
      end
    end

    def process_content
      content = @trigger
      content += "\n#{ @next_lines.shift }" until @next_lines.first.empty?
      content += "\n#{ @next_lines.shift }"
      yield content
    end

    def match_content(content)
      match = BODY_REGEX.match(content)

      if match
        yield match
      else
        Logger.info("Unknown warning format: #{ content }")
      end
    end
  end
end
