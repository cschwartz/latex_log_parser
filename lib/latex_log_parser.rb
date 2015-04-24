require 'pry'
require 'logger'

require 'line'
require 'error'
require 'warning'

module LatexLogParser
  Logger = Logger.new STDOUT

  # Parse latex log files for errors
  class Parser
    attr_reader :errors, :warnings
    LINE_TYPES = [Error, Warning, Ignore]
    def initialize(log_content)
      @errors = []
      @warnings = []

      parse log_content
    end

    def parse(log)
      LineRewrapper.new(log).rewrap do |wrapped_lines|
        @lines = wrapped_lines
        consume(@lines.shift) until @lines.empty?
      end
    end

    def consume(line)
      class_for_line(line, @lines).process(self)
    end

    def add_error(error)
      @errors << error
    end

    def add_warning(warning)
      @warnings << warning
    end

    def class_for_line(line, lines)
      LINE_TYPES.map { |t| t.instance_for_line(line, lines) }.compact.first
    end
  end
end
