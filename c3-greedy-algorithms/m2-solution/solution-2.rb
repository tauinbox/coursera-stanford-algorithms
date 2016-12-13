# Clustering Algorithm.

# The question is: what is the largest value of k such that there is a k-clustering with spacing at least 3? 
# That is, how many clusters are needed to ensure that no pair of nodes with all but 2 bits in common get split into different clusters?

###########################################################################################################################

class Cluster

  attr_reader :num_vertices, :groups

  def initialize(filedata)
    # a hash of unduplicated nodes
    @nodes = {}

    # hash of united groups
    @groups = {}

    # hash of leader pointers
    @leader_pointers = {}

    # generate the list of numbers which we'll use by XOR operation to find 2-bits hamming distance
    @hamming = generate_hamming_array    

    # initialize
    load_data filedata

    puts "\nStart calculating the number of clusters..."

    # process data
    clusterize
  end

  # Find closest nodes which are consisted in @nodes by passing through hamming list with XOR operation
  def closest_for(node)
    result = []
    @hamming.each do |number|
      # check if (node XOR number) is already in the nodes hash
      if @nodes[node ^ number]
        result << (node ^ number)
      end
    end
    return result
  end

  # generate an array for 2-bits hamming distance (the number of differing bits)
  # (the number of clusters are needed to ensure that no pair of nodes with all but 2 bits in common get split into different clusters)
  def generate_hamming_array
    data = []
    for i in (0..23)
      for j in (i..23)
        bitmask = 1 << i
        bitmask2 = 1 << j
        data << (bitmask | bitmask2)
      end
    end
    return data
  end 

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(" ")
        if line.length == 2
          @num_vertices = line[0]
          next
        else
          node = line.join.to_i(2)
          # setup the list of unduplicated nodes (hash)
          @nodes[node] = true
          # setup leader pointers
          @leader_pointers[node] = node
          # setup groups (clusters)
          @groups[node] = [node]
        end
      end
    end
  end

  def union(node1, node2)
    group1 = @leader_pointers[node1]
    group2 = @leader_pointers[node2]

    if @groups[group1].length <= @groups[group2].length
      # group1 happens to be merged and destroyed

      # puts "\nMove #{@groups[group1].inspect} to #{@groups[group2].inspect}"
      @groups[group1].each do |item|
        @groups[group2] << item
        @leader_pointers[item] = group2
      end
      # puts "Result: #{@groups[group2].inspect}, Leader: #{group2}"
      # puts "Delete group #{group1}"
      @groups.delete(group1)
    else
      # group2 happens to be merged and destroyed

      # puts "\nMove #{@groups[group2].inspect} to #{@groups[group1].inspect}"
      @groups[group2].each do |item|
        @groups[group1] << item
        @leader_pointers[item] = group1
      end
      # puts "Result: #{@groups[group1].inspect}, Leader: #{group1}"
      # puts "Delete group #{group2}"
      @groups.delete(group2)
    end
  end

  def clusterize
    @nodes.each do |k, v|
      # get an array of closest nodes for each node in list
      closest = closest_for(k)

      # unify them in clusters
      closest.each do |node|
        if @leader_pointers[k] != @leader_pointers[node]
          union(k, node)
        end
      end
    end    
  end

end

###########################################################################################################################

input_file = 'clustering_big.txt'
# input_file = 'testArray.txt'

solution = Cluster.new(input_file)

puts "\n----------------------------------------------------------------------"
puts "2. Clustering Algorithm. We have #{solution.groups.length} clusters with spacing at least 3"
puts "----------------------------------------------------------------------\n"
