require 'parse_csv'

last=1377
resumes = ParseCsv.new(ARGV[0]).parse.select{|resume| /.*RES-13-(.*)/.match(resume[0])[1].to_i > last}.map {|candidate| candidate[3]}

#resumes = resumes[ARGV[1].to_i..-1]

#resumes.each{|resume| puts resume}
resumes.each_index {|index| `wget --directory-prefix=#{index/10} #{resumes[index]}`}

