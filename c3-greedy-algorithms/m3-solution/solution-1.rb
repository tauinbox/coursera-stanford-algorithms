# Huffman Coding Algorithm

# Run the Huffman coding algorithm from lecture on provided data set.
# Report the maximum length of a codeword in the resulting Huffman code

###########################################################################################################################

# Monkey patching of Array class, added a new method to swap elements

class Array
  def swap!(a, b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

###########################################################################################################################

class Huffman

  attr_reader :max_length, :number_of_symbols

  def initialize(filedata)
    # @symbols = {}
    @min_heap = []

    load_data filedata

    # @symbols = @symbols.sort_by {|k, v| v}.to_h
    puts "\nInitialized heap:\n\n#{@min_heap.inspect}"

    first = extract_min
    second = extract_min

    puts "\nGot 2 lowest elements: #{first} and #{second}"    

  end

  def construct_tree()

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      line_num = 0
      File.foreach (filename) do |line|
        line_num += 1
        line = line.chomp.to_i
        if line_num == 1
          @number_of_symbols = line 
        else
          # @symbols[line_num - 1] = line
          insert line
        end
      end
    end
  end

  # min-heap (@min_heap)
  def insert(key)
    # puts "[INSERT] add #{key} to the end of heap"
    @min_heap << key
    heapify(@min_heap.length - 1)
  end

  # min-heap (@min_heap)
  def heapify(index)
    parent = parent(@min_heap, index)
    if parent
      if parent[0] > @min_heap[index]
        # puts "[HEAPIFY] swap node (#{index}) #{@min_heap[index]} with parent (#{parent[1]}) #{parent[0]}"
        @min_heap.swap!(parent[1], index)
        heapify(parent[1])
      end
    end    
  end

  def get_min
    @min_heap[0] ? @min_heap[0] : false
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
    @min_heap.swap!(0, @min_heap.length - 1)
    min = @min_heap.pop
    restore_after_extraction_min(0)
    return min
  end

  def restore_after_extraction_min(index)
    left_child = left_child(@min_heap, index)
    right_child = right_child(@min_heap, index)

    # puts "[- MIN] restoring from node (#{index}) #{@min_heap[index]}"

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

    if child_to_compare[0] < @min_heap[index]
      # puts "[- MIN] swap (#{child_to_compare[1]}) #{child_to_compare[0]} with parent (#{index}) #{@min_heap[index]}"
      @min_heap.swap!(index, child_to_compare[1])
      restore_after_extraction_min(child_to_compare[1])
    end
  end

end

###########################################################################################################################

input_file = 'huffman.txt'
# input_file = 'testArray.txt'

solution = Huffman.new(input_file)

puts "\n-----------------------------------------------------------------------"
puts "1. Huffman Algorithm. The maximum length of a codeword is: #{@max_length}"
puts "-----------------------------------------------------------------------\n"
