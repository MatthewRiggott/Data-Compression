
require 'pry'

class Trie < Hash
  def initialize
    super
  end

  def build2(string, value)

    string.chars.each_with_index do |c, index|
      cur = self
      if index <= string.length
        if hash.keys.include? c
          cur = cur[c]
        else
          cur[c] = {}
          cur = cur[c]
        end
      else
        cur[c] = value
      end
    end
  end

  def build(string, value)
    (string+value).chars.inject(self) do |h, char|
      h[char] ||= { }
    end
  end

  #if hash[key] = nil return value
  def decompress_binary_to_file(binary, filename)
    return_string = ""
    cur = self
    (binary + "^").chars.each do |c|
      if cur[c] == nil
        return_string = return_string + cur.keys[0] unless cur.keys[0].nil?
        cur = self
        cur = cur[c]
      else
        cur = cur[c]
      end
    end
    binding.pry
    File.open(filename, 'w+') {|f| f.write(return_string) }
  end
end

def file()
  return "The cat in the Hat hopped over the quick hawk!! ~~"
end

def get_count(text_str)
  letters = Hash.new
  text_str.each_char do |letter|
    letters[letter] = 0 if letters[letter] == nil
    letters[letter] = letters[letter] + 1
  end
  letters = Hash[letters.sort_by { |letter, count| count}]
end

# arr - [weight , let] + .. = [new_weight, [let,let]]
def new_dictionary(sorted_hash)
  weighted_tree = Array.new
  stop = sorted_hash.values.reduce(:+)
  results = Hash.new

  sorted_hash.each do |let, val|
    results[let] = ""
    weighted_tree.push  [val, [let]]
  end
  weighted_tree = weighted_tree.sort_by{|x| x[0]}

  loop do
    node_value = weighted_tree[0].shift + weighted_tree[1].shift
    left, right = weighted_tree.shift[0], weighted_tree.shift[0]
    new_node = [node_value, left + right]

    left.each do |path|
      results[path] = "0" + results[path]
    end
    right.each do |path|
      results[path] = "1" + results[path]
    end
    if node_value >= stop
      break
    end
    weighted_tree.each_with_index do |node, index|
      if node_value <= node[0]
        weighted_tree.insert(index, new_node)
        break
      else
        weighted_tree.push new_node
        break
      end
    end
  end
  return results
end

def get_file(filepath)
  file = File.read(filepath)
  return file
end

def fetch_dictionary(binary)
  dict_string = binary.gsub(/({.+})/)
  eval(dict_string.to_a[0])
end

def fetch_content(binary)
  bin = binary.gsub(/}(.+)/).to_a[0]
  bin[0] = ""
  return bin
end

def encode_text(text, dictionary)
  encrypter = dictionary
  binary_out = ""
  text.each_char do |letter|
    binary_out = binary_out + encrypter[letter]
  end
  binary_out
end


def run_compression_script
  arg0 = nil
  arg1 = nil
  if ARGV[0].nil? && ARGV[1].nil?
    puts "Need to enter -filepath and (-C)ompress or (-U)ncompress"
    return nil
  else
    arg0 = ARGV[0].reverse.chop.reverse
    arg1 = ARGV[1].reverse.chop.reverse
  end
  file = get_file(arg0)

  if arg1.upcase == "C"
    #compress
    puts "zipping #{arg1}"
    frequency = get_count(get_file(arg0))
    chart = new_dictionary(frequency).to_h
    binary_encoding = encode_text(get_file(arg0), chart)
    output = chart.to_s + binary_encoding
    File.open("#{arg0}.compressed", 'w+') {|f| f.write(output) }

  elsif arg1.upcase == "U"
    #uncompress
    trie = Trie.new
    puts "unzipping #{arg0}"
    file = File.open("#{arg0}", 'r')
    contents = file.read
    decoder = fetch_dictionary(contents)
    content = fetch_content(contents)
    decoder.each do |k, v|
      trie.build(v, k)
    end
    arg0.slice!('.compressed')
    filename = arg0.insert(-5, '-uncompressed')
    trie.decompress_binary_to_file(content, filename)
  else
    puts "Invalid argument. '-C' to compress, '-U' to decompress."
  end

end
t = Trie.new
run_compression_script

# puts "building decompression tree"
# chart.each do |k, v|
#   t.build(v, k)
# end
# puts "Decompressing......"
# puts t.get_vals(binary_encoding)

