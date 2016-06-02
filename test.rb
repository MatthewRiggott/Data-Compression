require 'benchmark'
string = "x"*10000000
arr = []
Benchmark.bm do |x|

  #x.report { string.scan(/./)}

  x.report { string.each_char{|c| arr << c}}

  x.report { string.each_char{|c| arr.push c}}

  #x.report { string.split("")}



end
