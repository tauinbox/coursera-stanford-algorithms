class Array
  def swap!(a,b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

###########################################################################################################################

def load_data(filename)

  a = []

  if File.exist? filename
    File.foreach (filename) do |line|
      a << line.chomp.to_i
    end
  end

  return a

end

###########################################################################################################################

def quick_sort(a, l, r)

  @comparisons ||= 0

  # n = a.length
  # return 1 if n == 1
  # return if (r - l) == 1

  # p, p_index = choose_pivot(a)
  p_index = l
  p = a[l]

  puts
  puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- STARTING with A: #{a[l..r]}, p: #{p}, p_index: #{p_index}, l=#{l}, r=#{r}"

  a.swap!(0, p_index) if p_index > 0

  i = l + 1

  for j in (l + 1)..r
    puts "i = #{i}, j = #{j}, looking at #{a[j]}"

    if a[j] < p
      puts "--------------------------  swap a[#{j}]=#{a[j]} with a[#{i}]=#{a[i]}"
      a.swap!(j, i)
      puts "A: #{a[l..r]}"
      i += 1        
    end
    @comparisons += 1
  end

  puts "Scan completed... i = #{i}, j = #{j}"
  puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- DONE result before swapping the pivot: #{a[l, r]}"

  # swap the pivot with the right most element which is smaller than the pivot
  a.swap!(p_index, (i - 1))
  puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- DONE result afer swapping the pivot:   #{a[l, r]}"

  # puts "parts:"

  # if i > 1
  #   # puts "#{a[0..i-2]}"
  #   quick_sort(a, 0, i-2)
  # end
  # if (i - r) > 1
  #   # puts "#{a[i..r]}"
  #   quick_sort(a, i, r)
  # end

      

  # puts "#{a[0..i-2]} - #{a[i..r]}"

  # quick_sort(a, 0, i-2)
  # quick_sort(a, i, r)

  # puts "A: #{a}"

end

###########################################################################################################################

# def choose_pivot(a)
#   return [a[0], 0]
# end

###########################################################################################################################

# input_file = 'QuickSort.txt'
input_file = 'TestArray.txt'

a = load_data input_file
r = a.length - 1

quick_sort(a, 0, r)
puts @comparisons


