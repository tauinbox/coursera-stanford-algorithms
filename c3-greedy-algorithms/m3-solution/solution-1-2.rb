# Huffman Coding Algorithm

# Run the Huffman coding algorithm from lecture on provided data set.

# 1. Report the maximum length of a codeword in the resulting Huffman code
# 2. Report the minimum length of a codeword in the resulting Huffman code

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

  attr_reader :min_length, :max_length, :number_of_symbols

  def initialize(filedata)
    
    # min-heap is using to select minimum weighted symbols in given alphabet
    @min_heap = []

    # hash of lengths per each weight in input data
    @length = {}

    # tree hash
    @tree = {}

    # hash of parents of nodes of the tree
    @parents = {}

    # array of input weights of symbols (from input file)
    @input_weights = []

    load_data filedata
    construct_tree
    calculate_length
  end

  def calculate_length
    @input_weights.each do |node|
      current_node = node
      while true do
        parent = @parents[current_node]
        break if !parent
        
        @length[node] = @length[node] ? @length[node] + 1 : 2
        current_node = parent
      end
    end

    # sort length by value in ascending order
    @length = @length.sort_by {|k, v| v}.to_h

    # set min and max values
    @min_length = @length.values.first
    @max_length = @length.values.last    
  end

  def construct_tree

    # basecase
    if @min_heap.length == 2
      elem1 = extract_min
      elem2 = extract_min      
      hash = { 0 => elem1, 1 => elem2 }
      @tree[elem1 + elem2] = hash
      return

    else
      # choose two elements
      elem1 = extract_min
      elem2 = extract_min

      # puts "\nGot 2 lowest elements: #{elem1} and #{elem2}, fuse them and go further!"

      insert(elem1 + elem2)
      hash = { 0 => elem1, 1 => elem2 }

      # recursive function call
      construct_tree

      # setup the tree and parents for each node
      @tree[elem1 + elem2] = hash
      @parents[elem1] = elem1 + elem2
      @parents[elem2] = elem1 + elem2
    end
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
          @input_weights << line
          insert line
        end
      end
    end
  end

  ############################################### Min Heap Methods #########################################

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

    # puts "restoring from node (#{index}) #{@min_heap[index]}"

    if left_child && right_child
      # puts "left_child (#{left_child[1]}) #{left_child[0]}, right_child (#{right_child[1]}) #{right_child[0]}"
      if left_child[0] < right_child[0]
        # puts "chosen left_child (#{left_child[1]}) #{left_child[0]} instead of right_child (#{right_child[1]}) #{right_child[0]}"
        child_to_compare = left_child
      else
        # puts "chosen right_child (#{right_child[1]}) #{right_child[0]} instead of left_child (#{left_child[1]}) #{left_child[0]}"
        child_to_compare = right_child
      end
    elsif left_child && !right_child
      # puts "chosen left_child (#{left_child[1]}) #{left_child[0]}"
      child_to_compare = left_child
    elsif !left_child && right_child
      # puts "chosen right_child (#{right_child[1]}) #{right_child[0]}"
      child_to_compare = right_child
    else
      # puts "no children found, return!"
      return
    end

    if child_to_compare[0] < @min_heap[index]
      # puts "swap (#{child_to_compare[1]}) #{child_to_compare[0]} with parent (#{index}) #{@min_heap[index]}"
      @min_heap.swap!(index, child_to_compare[1])
      restore_after_extraction_min(child_to_compare[1])
    end
  end

  ############################################### Min Heap Methods #########################################

end

###########################################################################################################################

input_file = 'huffman.txt'
# input_file = 'testArray.txt'

solution = Huffman.new(input_file)

puts "\n-----------------------------------------------------------------------"
puts "Huffman Algorithm.\n\r"
puts "1. The maximum length of a codeword is: #{solution.max_length}"
puts "2. The minimum length of a codeword is: #{solution.min_length}"
puts "-----------------------------------------------------------------------\n"
