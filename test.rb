require 'pp'

sjis = File.open('/Users/kozo/Desktop/one_sjis.txt', 'r:shift_jis')
utf8 = File.open('/Users/kozo/Desktop/one_utf8.txt', 'r:utf-8')

pp 'UTF8 string'
pp utf8.read

incompatible_chars = [
  {
    desc: '丸の中に数字の1',
    sjis: 34624,
    utf8: 9312,
  }
]

sjis_codepoints = sjis.read.each_codepoint.to_a

pp 'SJIS codepoints'
pp sjis_codepoints
pp '----------'

result = []

sjis_codepoints.each do |sjc|
  ic = incompatible_chars.detect{|ic| ic[:sjis] == sjc }
  char = if ic != nil
    ic[:utf8].chr(Encoding::UTF_8)
  else
    begin
      sjc.chr(Encoding::SHIFT_JIS).encode(Encoding::UTF_8)
    rescue => e
      pp "#{e.inspect} / #{sjc} / #{sjc.chr(Encoding::SHIFT_JIS)}"
      '?'
    end
  end
  result << char
end

pp 'converted UTF8 string from SJIS'
pp result.join
