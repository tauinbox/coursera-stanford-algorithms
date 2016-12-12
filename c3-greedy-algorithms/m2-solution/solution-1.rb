# Clustering Algorithm (using Kruskal's MST algorithm).

# Run the clustering algorithm on provided data set, where the target number k of clusters is set to 4.
# Report the maximum spacing of a 4-clustering

###########################################################################################################################

class Cluster

  attr_reader :edges, :num_vertices, :max_spacing

  def initialize(filedata)

    @edges = []
    @groups = {}
    @leader_pointers = {}
    load_data filedata
    puts @groups.inspect
    puts @leader_pointers.inspect
    # puts @groups.length
    # gets
    # puts @edges.inspect

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
      @groups[group1].each do |item|
        @groups[group2] << item
        @leader_pointers[item] = group2
      end
      @groups.delete(group1)
    else
      @groups[group2].each do |item|
        @groups[group1] << item
        @leader_pointers[item] = group1
      end      
      @groups.delete(group2)
    end

  end

end

###########################################################################################################################

input_file = 'clustering1.txt'
# input_file = 'testArray.txt'

solution = Cluster.new(input_file)

puts "\n--------------------------------------------------------------------"
puts "1. Clustering Algorithm. The maximum spacing of a 4-clustering: #{solution.max_spacing}"
puts "--------------------------------------------------------------------\n"
