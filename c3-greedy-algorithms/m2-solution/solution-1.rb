# Clustering Algorithm.

# Run the clustering algorithm on provided data set, where the target number k of clusters is set to 4.
# Report the maximum spacing of a 4-clustering

###########################################################################################################################

class Cluster

  attr_reader :num_edges, :num_vertices, :max_spacing

  def initialize(filedata)

    # init undirected graph by loading data from file
    # graph structure example:
    # {
    #  node1 => {node2 => cost, node3 => cost},
    #  node2 => {node1 => cost, node5 => cost}, ...
    # }
    @graph = {}
    load_data filedata
    # puts @graph.inspect
    # puts @graph.length

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(" ").map(&:to_i)
        if line.length == 2
          @num_vertices = line[0]
          @num_edges = line[1]
          next
        else
          @graph[line[0]] = Hash.new if !@graph[line[0]]
          @graph[line[1]] = Hash.new if !@graph[line[1]]
          @graph[line[0]][line[1]] = line[2]
          @graph[line[1]][line[0]] = line[2]
        end
      end
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
