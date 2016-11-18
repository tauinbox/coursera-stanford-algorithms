# "Median Maintenance" Algorithm (on heap applications)

# Calculate the sum of given 10000 medians, modulo 10000 
# i.e. (m1+m2+m3+...+m10000)mod10000

###########################################################################################################################

# Monkey patching of Array class, added a new method to swap elements

class Array
  def swap!(a, b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

###########################################################################################################################

class MedianMaintenance

  attr_reader :sum_of_medians

  def initialize(filedata)

    # max-heap for lowest half of stream
    @heap_low = []

    # min-heap for highest half of stream
    @heap_high = []

    @stream = []

    @sum_of_medians = 0

    # initialize data from file
    load_data filedata

    process_stream

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        @stream << line.chomp.to_i
      end
    end
  end

  def process_stream

    # File.open("output.txt", 'w') do |f|
    
      # set the very first element as 1st median
      median = @stream[0]
      @sum_of_medians += median

      # f.puts "M1: #{median}, SUM: #{sum_of_medians}"

      # puts "\nreceived #{@stream[0]}"
      # puts "\n[1] Median is #{median}, Sum = #{@sum_of_medians}"

      # choose which one of the first two elements going to be ether in Hlow or Hhigh
      if @stream[0] < @stream[1]
        insert_low(@stream[0])
        insert_high(@stream[1])
      else
        insert_low(@stream[1])
        insert_high(@stream[0])
      end

      # set the median 2 as the smallest of two (get_max returns max from the lower heap)
      median = get_max
      @sum_of_medians += median

      # f.puts "M2: #{median}, SUM: #{sum_of_medians}"

      # puts "\nreceived #{@stream[1]}"
      # puts "\n[2] Median is #{median}, Sum = #{@sum_of_medians}"

      # puts "\nNow we have:\nHlow (#{@heap_low.length}): #{@heap_low.inspect}\nHhigh(#{@heap_high.length}): #{@heap_high.inspect}\n\r"      

      @stream[2..@stream.length].each_with_index do |key, index|

        # puts "------------------------------------------------------------\nreceived #{key}\n\r"

        # put each incoming element into one of two heaps
        if key < get_max
          # puts "...sending it to Hlow"
          insert_low(key)
        else
          # puts "...sending it to Hhigh"
          insert_high(key)
        end

        # puts "\nNow we have:\nHlow (#{@heap_low.length}): #{@heap_low.inspect}\nHhigh(#{@heap_high.length}): #{@heap_high.inspect}\n\r"

        if (@heap_high.length - @heap_low.length > 1)
          # puts "[BALANCING -> LOW] Take out #{get_min} from Hhigh and send it to Hlow"
          insert_low(extract_min)
        elsif (@heap_low.length - @heap_high.length > 1)
          # puts "[BALANCING -> HIGH] Take out #{get_max} from Hlow and send it to Hhigh"
          insert_high(extract_max)
        end

        # select median
        if @heap_low.length == @heap_high.length
          median = get_max
        elsif @heap_low.length < @heap_high.length
          median = get_min
        else
          median = get_max
        end

        @sum_of_medians += median

        # puts "\nHlow (#{@heap_low.length}): #{@heap_low.inspect}\nHhigh(#{@heap_high.length}): #{@heap_high.inspect}\n"
        # puts "\n[#{index + 3}] Median is #{median}, Sum = #{@sum_of_medians}"
        # gets
        # f.puts "M#{index + 3}: #{median}, SUM: #{sum_of_medians}"
      end
    # end

  end

  # max-heap (@heap_low)
  def insert_low(key)
    # puts "[INSERT TO LOW] add #{key} to the end of LOW heap"
    @heap_low << key
    heapify_low(@heap_low.length - 1)
  end

  # min-heap (@heap_high)
  def insert_high(key)
    # puts "[INSERT TO HIGH] add #{key} to the end of HIGH heap"
    @heap_high << key
    heapify_high(@heap_high.length - 1)
  end

  # max-heap (@heap_low)
  def heapify_low(index)
    parent = parent(@heap_low, index)
    if parent
      if parent[0] < @heap_low[index]
        # puts "[HEAPIFY LOW] swap node (#{index}) #{@heap_low[index]} with parent (#{parent[1]}) #{parent[0]}"
        @heap_low.swap!(parent[1], index)
        heapify_low(parent[1])
      end
    end
  end

  # min-heap (@heap_high)
  def heapify_high(index)
    parent = parent(@heap_high, index)
    if parent
      if parent[0] > @heap_high[index]
        # puts "[HEAPIFY HIGH] swap node (#{index}) #{@heap_high[index]} with parent (#{parent[1]}) #{parent[0]}"
        @heap_high.swap!(parent[1], index)
        heapify_high(parent[1])
      end
    end    
  end

  def get_min
    @heap_high[0] ? @heap_high[0] : false
  end

  def get_max
    @heap_low[0] ? @heap_low[0] : false
  end

  def parent(heap, index)
    index > 0 ? [heap[((index - 1) / 2).floor], ((index - 1) / 2).floor] : false
  end

  def left_child(heap, index)
    idx = 2 * index + 1
    heap[idx] ? [heap[idx], idx] : false
  end

  def right_child(heap, index)
    idx = 2 * index + 2
    heap[idx] ? [heap[idx], idx] : false
  end

  def extract_min
    @heap_high.swap!(0, @heap_high.length - 1)
    min = @heap_high.pop
    restore_after_extraction_min(0)
    return min
  end

  def extract_max
    @heap_low.swap!(0, @heap_low.length - 1)
    max = @heap_low.pop
    restore_after_extraction_max(0)
    return max
  end

  def restore_after_extraction_min(index)
    left_child = left_child(@heap_high, index)
    right_child = right_child(@heap_high, index)

    # puts "[- MIN] restoring from node (#{index}) #{@heap_high[index]}"

    if left_child && right_child
      # puts "[- MIN] left_child (#{left_child[1]}) #{left_child[0]}, right_child (#{right_child[1]}) #{right_child[0]}"
      if left_child[0] < right_child[0]
        # puts "[- MIN] chosen left_child (#{left_child[1]}) #{left_child[0]} instead of right_child (#{right_child[1]}) #{right_child[0]}"
        child_to_compare = left_child
      else
        # puts "[- MIN] chosen right_child (#{right_child[1]}) #{right_child[0]} instead of left_child (#{left_child[1]}) #{left_child[0]}"
        child_to_compare = right_child
      end
    elsif left_child && !right_child
      # puts "[- MIN] chosen left_child (#{left_child[1]}) #{left_child[0]}"
      child_to_compare = left_child
    elsif !left_child && right_child
      # puts "[- MIN] chosen right_child (#{right_child[1]}) #{right_child[0]}"
      child_to_compare = right_child
    else
      # puts "[- MIN] no children found, return!"
      return
    end

    if child_to_compare[0] < @heap_high[index]
      # puts "[- MIN] swap (#{child_to_compare[1]}) #{child_to_compare[0]} with parent (#{index}) #{@heap_high[index]}"
      @heap_high.swap!(index, child_to_compare[1])
      restore_after_extraction_min(child_to_compare[1])
    end
  end

  def restore_after_extraction_max(index)
    left_child = left_child(@heap_low, index)
    right_child = right_child(@heap_low, index)

    # puts "[- MAX] restoring from node (#{index}) #{@heap_low[index]}"

    if left_child && right_child
      # puts "[- MAX] left_child (#{left_child[1]}) #{left_child[0]}, right_child (#{right_child[1]}) #{right_child[0]}"
      if left_child[0] > right_child[0]
        # puts "[- MAX] chosen left_child (#{left_child[1]}) #{left_child[0]} instead of right_child (#{right_child[1]}) #{right_child[0]}"
        child_to_compare = left_child
      else
        # puts "[- MAX] chosen right_child (#{right_child[1]}) #{right_child[0]} instead of left_child (#{left_child[1]}) #{left_child[0]}"
        child_to_compare = right_child
      end
    elsif left_child && !right_child
      # puts "[- MAX] chosen left_child (#{left_child[1]}) #{left_child[0]}"
      child_to_compare = left_child
    elsif !left_child && right_child
      # puts "[- MAX] chosen right_child (#{right_child[1]}) #{right_child[0]}"
      child_to_compare = right_child
    else
      # puts "[- MAX] no children found, return!"
      return
    end

    if child_to_compare[0] > @heap_low[index]
      # puts "[- MAX] swap (#{child_to_compare[1]}) #{child_to_compare[0]} with parent (#{index}) #{@heap_high[index]}"
      @heap_low.swap!(index, child_to_compare[1])
      restore_after_extraction_max(child_to_compare[1])
    end    
  end

end

###########################################################################################################################

input_file = 'Median.txt'
# input_file = 'testArray.txt'

solution = MedianMaintenance.new(input_file)

puts "\n-------------------------------------------------"
puts "The sum of given 10000 medians: #{solution.sum_of_medians}\n                  Modulo 10000: #{solution.sum_of_medians % 10000}"
puts "-------------------------------------------------\n"
