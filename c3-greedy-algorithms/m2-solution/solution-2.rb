# Clustering Algorithm (using Kruskal's MST algorithm).

# Run the clustering algorithm on provided data set, where the target number k of clusters is set to 4.
# Report the maximum spacing of a 4-clustering

###########################################################################################################################

class Cluster

  attr_reader :edges, :num_vertices, :groups, :num_clusters

  def initialize(filedata, spacing)

    @edges = []
    @nodes = []

    # hash of united groups
    @groups = {}

    # hash of leader pointers
    @leader_pointers = {}

    # setup 
    load_data filedata

    previous = @nodes[0]
    @nodes.each_with_index do |cost, index|
      next if index == 0
      distance = ((cost[0].to_i(2) ^ previous[0].to_i(2)).to_s(2)).count('1')
      # puts "#{previous} - #{cost}. Diff = #{distance}"
      # gets
      @edges << [distance, previous[1], cost[1]]
      previous = cost
    end

    @edges.sort!
    # puts "Edges:\n#{@edges.inspect}"
    # puts "Edges:\n#{@edges.length}"
    # puts "Groups:\n#{@groups.length}"

    # @edges.each do |edge|
    #   puts edge.inspect
    # end

    # puts @leader_pointers

    clusterize(spacing)

  end

  # Method for loading data from file
  def load_data(filename)
    node_name = 0
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(" ")
        if line.length == 2
          @num_vertices = line[0]
          next
        else
          node = line.join
          @nodes << [node, node_name]
          @leader_pointers[node_name] = node_name
          @groups[node_name] = [node_name]
          node_name += 1
        end
      end
    end
    # sort nodes
    @nodes.sort! { |a, b| a[0] <=> b[0] }
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

  def clusterize(spacing)

    @edges.each do |edge|
      if edge[0] == spacing + 1
        @num_clusters = @groups.length
        puts "Found spacing: #{edge.inspect}"
        break
      end

      # if there is no cycle
      if @leader_pointers[edge[1]] != @leader_pointers[edge[2]]
        puts "\nCoalesce 2 vertices: #{edge[1]} and #{edge[2]} with distance between them: #{edge[0]}"
        puts "Number of groups: #{@groups.length}"

        # let's unite two points
        union(edge[1], edge[2])

      else
        # puts "Found cycle, #{edge[1]} and #{edge[2]} are in the same group: #{@leader_pointers[edge[1]]}"
      end
            
    end    
  end

end

###########################################################################################################################

input_file = 'clustering_big.txt'
# input_file = 'testArray.txt'

solution = Cluster.new(input_file, 3)

puts "\n-----------------------------------------------------------------------"
puts "1. Clustering Algorithm. The largest value of k is #{solution.num_clusters}"
puts "-----------------------------------------------------------------------\n"
