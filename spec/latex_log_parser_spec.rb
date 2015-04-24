require 'latex_log_parser'

RSpec.describe LatexLogParser::Parser, '#parse' do
  let(:log_file) { IO.read(File.join 'spec', 'fixtures', 'errors.log') }
  let(:parser) { LatexLogParser::Parser.new(log_file) }

  context 'with errors' do
    it 'should return 2 errors' do
      expect(parser.errors.count).to be 2
    end

    it 'should find the undefined control sequence' do
      error = {
        message: 'Undefined control sequence.',
        line_number: 31
      }
      expect(parser.errors).to include have_attributes error
    end

    it 'should find the number of closing brackets' do
      error = {
        message: 'Too many }\'s.',
        line_number: 31
      }
      expect(parser.errors).to include have_attributes error
    end
  end

  context 'with warnings' do
    it 'should return 1 warning' do
      expect(parser.warnings.count).to be 1
    end

    it 'should find the biblatex warning' do
      warning = {
        package: 'biblatex',
        details: 'The following entry could not be found in the database: Schwartz2015 Please verify the spelling and rerun LaTeX afterwards.'
      }
      expect(parser.warnings).to include have_attributes warning
    end
  end
end
