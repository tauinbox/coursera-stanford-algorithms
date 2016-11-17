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

    if @stream[0] < @stream[1]
      insert_low(@stream[0])
      insert_high(@stream[1])
    else
      insert_low(@stream[1])
      insert_high(@stream[0])
    end

    median = (get_min + get_max).to_f / 2
    @sum_of_medians = median

    puts "\nMedian is #{median}, Sum = #{@sum_of_medians}"

    @stream[2..@stream.length].each_with_index do |key, index|

      if key < get_max
        insert_low(key)
      else
        insert_high(key)
      end

      puts "-----------------------------\n[#{index + 3}] Now we have:\nHlow:  #{@heap_low.inspect}\nHhigh: #{@heap_high.inspect}"

      insert_low(extract_min) if (@heap_high.length - @heap_low.length > 1)
      insert_high(extract_max) if (@heap_low.length - @heap_high.length > 1)

      if @heap_low.length == @heap_high.length
        median = (get_min + get_max).to_f / 2
      elsif @heap_low.length < @heap_high.length
        median = get_min.to_f
      else
        median = get_max.to_f
      end

      @sum_of_medians += median

      puts "\n...checking for balance - Hlow length: #{@heap_low.length}, Hhigh length: #{@heap_high.length}\nHlow:  #{@heap_low.inspect}\nHhigh: #{@heap_high.inspect}"
      puts "Median is #{median}, Sum = #{@sum_of_medians}"
      gets
    end

  end

  # max-heap (@heap_low)
  def insert_low(key)
    @heap_low << key
    heapify_low(@heap_low.length - 1)
  end

  # min-heap (@heap_high)
  def insert_high(key)
    @heap_high << key
    heapify_high(@heap_high.length - 1)
  end

  # max-heap (@heap_low)
  def heapify_low(index)
    parent = parent(@heap_low, index)
    if parent
      if parent[0] < @heap_low[index]
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
    index > 0 ? [heap[index / 2], index / 2] : false
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

    if left_child && right_child
      if left_child[0] < right_child[0]
        child_to_compare = left_child
      else
        child_to_compare = right_child
      end
    elsif left_child && !right_child
      child_to_compare = left_child
    elsif !left_child && right_child
      child_to_compare = right_child
    else
      return
    end

    if child_to_compare[0] < @heap_high[index]
      @heap_high.swap!(index, child_to_compare[1])
      restore_after_extraction_min(child_to_compare[1])
    end
  end

  def restore_after_extraction_max(index)
    left_child = left_child(@heap_low, index)
    right_child = right_child(@heap_low, index)

    if left_child && right_child
      if left_child[0] > right_child[0]
        child_to_compare = left_child
      else
        child_to_compare = right_child
      end
    elsif left_child && !right_child
      child_to_compare = left_child
    elsif !left_child && right_child
      child_to_compare = right_child
    else
      return
    end

    if child_to_compare[0] > @heap_low[index]
      @heap_low.swap!(index, child_to_compare[1])
      restore_after_extraction_max(child_to_compare[1])
    end    
  end

end

###########################################################################################################################

input_file = 'Median.txt'
# input_file = 'testArray.txt'

solution = MedianMaintenance.new(input_file)

# puts "\n-------------------------------------------------"
# puts "The sum of given 10000 medians, modulo 10000:\n#{solution.result}"
# puts "-------------------------------------------------\n"
