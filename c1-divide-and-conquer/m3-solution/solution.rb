class Array
  def swap!(a, b)
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

def quick_sort(a, l, r, pivot_logic)

  @comparisons ||= 0

  if (r - l) == 0
    puts "have only one element: #{a[l..r]}, nothing to sort"
    return a[l..r]
  end

  case pivot_logic
  when 'l'
    p_index = l
    p = a[l]
  when 'r'
    p_index = r
    p = a[r]
  end

  puts
  puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- STARTING with array: #{a[l..r]}, pivot = #{p}, p_index = #{p_index}, l=#{l}, r=#{r}"

  # put the pivot on the 1st place in given array
  if p_index > l
    puts "putting the pivot on the 1st place in given array"
    a.swap!(l, p_index) if p_index > l
    puts "now we have the array: #{a[l..r]}"
  end

  i = l + 1
  found_less_than_pivot = false

  for j in (l + 1)..r
    puts "i = #{i}, j = #{j}, looking at #{a[j]}"

    if a[j] < p
      found_less_than_pivot = true
      if i != j
        puts "--------------------------  swap a[#{j}]=#{a[j]} with a[#{i}]=#{a[i]}"
        a.swap!(i, j)
        puts "swapping done! resulting array: #{a[l..r]}"
      end
      i += 1
    end
    @comparisons += 1
  end

  puts "Scan completed... i = #{i}, j = #{j}"
  puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- processing done, now we have the array: #{a[l..r]}"

  if found_less_than_pivot
    a.swap!(p_index, i - 1)
    puts "put the pivot #{p} on its proper place (i - 1) = #{i - 1}"
    p_index = i - 1
  end

  puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- [DONE] result aray:  #{a[l..r]}, pivot = #{p}, p_index = #{p_index}, l = #{l}, r = #{r}, i = #{i}"
  puts

  if (p_index - l) > 0
    puts "left part is sending to sort: #{a[l..p_index-1]}"
    quick_sort(a, l, p_index - 1, pivot_logic)    
  end

  if (r - p_index) > 0
    puts "right part is sending to sort: #{a[p_index+1..r]}"
    quick_sort(a, p_index + 1, r, pivot_logic)
  end

  return a

end

###########################################################################################################################

# input_file = 'QuickSort.txt'
input_file = 'TestArray.txt'

a = load_data input_file
r = a.length - 1

puts "Final result: #{quick_sort(a, 0, r, 'l')}"
puts @comparisons

# gets

# @comparisons = 0
# puts "Final result: #{quick_sort(a, 0, r, 'r')}"
# puts @comparisons

