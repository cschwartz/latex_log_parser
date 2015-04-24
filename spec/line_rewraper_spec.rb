require 'line_rewrapper'

RSpec.describe LatexLogParser::LineRewrapper, '#parse' do
  let(:lines) do
    <<-EOS
abc
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
bbbbbb
d
EOS
  end

  it 'rewraps lines greater than 79 characters to one' do
    LatexLogParser::LineRewrapper.new(lines).rewrap do |rewrapped_lines|
      expect(rewrapped_lines).to match [
        a_string_matching(/abc/),
        a_string_matching(/a{79}b{6}/),
        a_string_matching(/d/)
      ]
    end
  end
end
