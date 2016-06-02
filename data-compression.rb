# YOUR CODE GOES HERE
require 'benchmark'
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
  def get_vals(binary)
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

    return return_string
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

def get_file()
  file = File.read("moby_dick_book.txt")
  return file
end

def decode(binary)


end

def encode_text(text, dictionary)
  encrypter = dictionary
  binary_out = ""
  text.each_char do |letter|
    if encrypter[letter].nil?
      binding.pry
    end
    binary_out = binary_out + encrypter[letter]
    # WRITE TO TEXT FILE
  end
  return binary_out
end

t = Trie.new

frequency = get_count(get_file)
chart = new_dictionary(frequency)
chart = chart.to_h
puts "binary mapping built"
binary_encoding = encode_text(get_file, chart)
puts binary_encoding
puts "building decompression tree"
chart.each do |k, v|
  t.build(v, k)
end
puts "Decompressing......"
puts t.get_vals(binary_encoding)

