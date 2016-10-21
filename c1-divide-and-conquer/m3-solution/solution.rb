###########################################################################################################################

# Monkey patching of Array class, added a new method to swap elements

class Array
  def swap!(a, b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

###########################################################################################################################

# Method for loading an array of data from file

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
    # puts "we have the only one element: #{a[l..r]}, nothing to sort, just return it"
    return a[l..r]
  end

  # select the pivot
  p_index = choose_pivot(a, l, r, pivot_logic)
  p = a[p_index]

  # put the pivot on the 1st place in given array
  if p_index > l
    # puts
    # puts "[CORRECTION] putting the pivot [#{p}] from (#{p_index}) to the (#{l}) place in given array..."
    a.swap!(l, p_index) if p_index > l
    p_index = l
  end

  # puts
  # puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- STARTING with array: #{a[l..r]}, pivot = #{p}, p_index = #{p_index}, l=#{l}, r=#{r}"

  # set up i position
  i = l + 1

  # initialize a flag
  found_less_than_pivot = false

  for j in (l + 1)..r
    # puts "i = #{i}, j = #{j}, looking at #{a[j]}"

    # we found an element which is less than our pivot
    if a[j] < p

      # set up the flag to true
      found_less_than_pivot = true

      # don't swap elements with same indices
      if i != j
        # puts "--------------------------  swap a[#{j}]=#{a[j]} with a[#{i}]=#{a[i]}"
        a.swap!(i, j)
        # puts "swapping done! resulting array: #{a[l..r]}"
      end
      i += 1
    end

    # increment the @comparisons counter
    @comparisons += 1
  end

  # puts "Scan completed... i = #{i}, j = #{j}"
  # puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- processing done, now we have the array: #{a[l..r]}"

  if found_less_than_pivot
    a.swap!(p_index, i - 1)
    # puts "put the pivot #{p} on its proper place (i - 1) = #{i - 1}"
    p_index = i - 1
  end

  # puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=- [DONE] result aray:  #{a[l..r]}, pivot = #{p}, p_index = #{p_index}, l = #{l}, r = #{r}, i = #{i}"
  # puts

  # if we have at least one element in array before the pivot (1st part)
  if (p_index - l) > 0
    # puts "left part is sending to sort: #{a[l..p_index-1]}"
    quick_sort(a, l, p_index - 1, pivot_logic)    
  end

  # if we have at least one element in array after the pivot (2nd part)
  if (r - p_index) > 0
    # puts "right part is sending to sort: #{a[p_index+1..r]}"
    quick_sort(a, p_index + 1, r, pivot_logic)
  end

  # return the result
  return a

end

###########################################################################################################################

def choose_pivot(a, l, r, pivot_logic)

  case pivot_logic

  # choose the pivot as most left (first) element of input array
  when 'pivot_is_first'
    p_index = l

  # choose the pivot as most right (last) element of input array    
  when 'pivot_is_last'
    p_index = r

  # choose the pivot randomly
  when 'pivot_is_random'
    p_index = rand(l..r)

  # by default we choose the 'pivot_is_median' strategy:
  # choose the pivot as a median among first, middle and last elements (using the "median-of-three" pivot rule)
  else
    if (r - l) == 1
      if a[l] < a[r]
        p_index = l
      else
        p_index = r
      end
    else
      three = {}

      # take the first element
      three[l] = a[l]

      middle = ((r - l).to_f/2).floor + l
      middle = l if middle < l

      # take the middle element
      three[middle] = a[middle]

      # take the last element
      three[r] = a[r]

      # calculate the index of the median element
      p_index = three.sort_by { |key, value| value }[1][0]

      # puts
      # puts "array a[#{l}..#{r}]: #{a[l..r]} ----------------------> left(#{l}): #{three[l]}, middle(#{middle}): #{three[middle]}, right(#{r}): #{three[r]}, median: #{a[p_index]}"
    end
  end

  return p_index  
end

###########################################################################################################################

input_file = 'QuickSort.txt'
# input_file = 'TestArray.txt'

a = load_data input_file
r = a.length - 1

@comparisons = 0
pivot_strategy = 'pivot_is_median'

# usage: quick_sort(Array, Left boundary of input array, Right boundary of input array, Pivot strategy)
result = quick_sort(a, 0, r, pivot_strategy)

puts result

puts "\n-----------------------------------------------------------"
puts "Used the '#{pivot_strategy}' strategy"
puts "Found #{@comparisons} comparisons during processing"
puts "-----------------------------------------------------------\n"
