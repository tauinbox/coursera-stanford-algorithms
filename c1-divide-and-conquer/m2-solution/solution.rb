
# MERGE SORT ALGORITHM

###########################################################################################################################

class MergeSort

  attr_reader :inversions, :result

  def initialize(filedata)
    a = load_data(filedata)
    @result = sort_and_count(a)
  end

  def load_data(filename)

    a ||= []

    if File.exist? filename
      File.foreach (filename) do |line|
        a << line.chomp.to_i
      end
    end

    return a

  end

  ###########################################################################################################################

  def sort_and_count(a)

    n = a.length
    return a if n == 1

    # divide and conquer!
    middle = (n.to_f/2).ceil

    left_half = a[0...middle]
    right_half = a[(middle)...n]

    # puts
    # puts "left_half is #{left_half}, right_half is #{right_half}"

    b = sort_and_count(left_half)
    c = sort_and_count(right_half)
    d = merge_and_count_inversions(b, c, n)

    return d

  end

  ###########################################################################################################################

  def merge_and_count_inversions(b, c, n)

    #initialize an inversions counter
    @inversions ||= 0

    out = []
    i = j = 0
    b_empty = c_empty = false

    n.times do
      # puts "i = #{i}, j = #{j}, n = #{n}"
      # puts

      # puts "b[#{i}] = #{b[i]}, c[#{j}] = #{c[j]}"
      # puts

      # puts "b.length: #{b.length}"
      # puts "c.length: #{c.length}"
      # puts

      # check if one of two parts (left and right) is empty
      if !b_empty && !c_empty

        if (b[i] <= c[j])
          # no inversion, just copy the smallest to output
          out << b[i]
          # puts "=== b < c === put #{b[i]} to out, out is #{out}"
          i += 1
          if (b.length - i) == 0
            b_empty = true
            # puts "b is empty"
          end
        else
          # we found inversion! means b[i] > c[j], take the smallest to output
          out << c[j]
          # puts "=== c < b === inversion detected! put #{c[j]} to out, out is #{out}"
          
          # check for all split inversions. means that all residual elements after 'i' in left part 'b' are split inversions
          # because 'b' is already sorted, so just count those inversions
          @inversions += (b.length - i)

          j += 1
          if (c.length - j) == 0
            c_empty = true
            # puts "c is empty"
          end
        end

      elsif b_empty
        out << c[j]
        # puts "b is already empty, geting #{c[j]} from c, out is #{out}"
        j += 1
        if (c.length - j) == 0
          c_empty = true
          # puts "c is empty"
        end
      elsif c_empty
        out << b[i]
        # puts "c is already empty, getting #{b[i]} from b, out is #{out}"      
        i += 1
        if (b.length - i) == 0
          b_empty = true
          # puts "b is empty"
        end
      end

    end

    # puts("++++++++++++++++++++ out: #{out} ++++++++++++++++++++")

    return out  

  end
end

###########################################################################################################################

input_file = 'IntegerArray.txt'
# input_file = 'TestArray.txt'

sorted_array = MergeSort.new(input_file)

# puts sorted_array.result

puts "\n-----------------------------------------------------------"
puts "Found #{sorted_array.inversions} inversions in input array #{input_file}"
puts "-----------------------------------------------------------\n"
