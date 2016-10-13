@a = []

def load_data(filename)
  if File.exist? filename
    File.foreach (filename) do |line|
      @a << line.chomp.to_i
    end
  end
end

# load_data 'IntegerArray.txt'
load_data 'TestArray.txt'

def merge_sort(a)

  n = a.length
  return a if n == 1

  middle = (n.to_f/2).ceil

  left_half = a[0...middle]
  right_half = a[(middle)...n]

  # puts("left: #{left_half}")
  # puts("right: #{right_half}")

  return merge(merge_sort(left_half), merge_sort(right_half))
end

def merge(a, b)

  return b if a.empty?
  return a if b.empty?

  a_n = a.length
  b_n = b.length

  if a[0] < b[0]
    return [a[0]].concat(merge(a[1...a_n], b))
  else
    return [b[0]].concat(merge(a, b[1...b_n]))
  end

end

puts merge_sort(@a)
