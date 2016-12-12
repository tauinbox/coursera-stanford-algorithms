# Clustering Algorithm (using Kruskal's MST algorithm).

# Run the clustering algorithm on provided data set, where the target number k of clusters is set to 4.
# Report the maximum spacing of a 4-clustering

###########################################################################################################################

class Cluster

  attr_reader :edges, :num_vertices, :groups, :max_spacing

  def initialize(filedata, k = 4)

    puts "\nStart searching the maximum spacing of a #{k}-clustering..."

    # array of edges in format:
    # [edge 1 cost, edge 1 node 1, edge 1 node 2],
    # [edge 2 cost, edge 2 node 1, edge 2 node 2],
    # ...
    @edges = []

    # hash of united groups
    @groups = {}

    # hash of leader pointers
    @leader_pointers = {}

    # setup edges, groups and leader_pointers
    load_data filedata

    # clusterize for k clusters and find the maximum spacing
    clusterize(k)
  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(" ").map(&:to_i)
        if line.length == 1
          @num_vertices = line[0]
          next
        else
          @edges << [line[2], line[0], line[1]]
          if !@groups[line[0]]
            @groups[line[0]] = [line[0]]
            @leader_pointers[line[0]] = line[0]
          end
          if !@groups[line[1]]
            @groups[line[1]] = [line[1]]
            @leader_pointers[line[1]] = line[1]
          end          
        end
      end
    end
    # sort edges costs
    @edges.sort! { |a, b| a[0] <=> b[0] }
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

  def clusterize(k)
    found = false
    last_edge = nil

    @edges.each do |edge|
      if found && last_edge != edge[0] && @leader_pointers[edge[1]] != @leader_pointers[edge[2]]
        @max_spacing = edge
        break
      else
        # if there is no cycle
        if @leader_pointers[edge[1]] != @leader_pointers[edge[2]]
          # puts "\nCoalesce 2 vertices: #{edge[1]} and #{edge[2]} with distance between them: #{edge[0]}"
          # puts "Number of groups: #{@groups.length}"

          # let's unite two points
          union(edge[1], edge[2])

          if @groups.length == k
            found = true
            last_edge = edge[0]
          end
        else
          # puts "Found cycle, #{edge[1]} and #{edge[2]} are in the same group: #{@leader_pointers[edge[1]]}"
        end
      end              
    end    
  end

end

###########################################################################################################################

input_file = 'clustering1.txt'
# input_file = 'testArray.txt'

solution = Cluster.new(input_file, 4)

puts "\n-----------------------------------------------------------------------"
puts "1. Clustering Algorithm. The maximum spacing is #{solution.max_spacing[0]} (nodes #{solution.max_spacing[1]} and #{solution.max_spacing[2]})"
puts "-----------------------------------------------------------------------\n"

# puts "\nClusters:\n\n#{solution.groups}"