# Travelling salesman problem (TSP)

# Compute the minimum cost of a traveling salesman tour for the given instance, rounded down to the nearest integer

###########################################################################################################################

class TSP

  attr_reader :num_edges, :num_vertices

  def initialize(filedata)

    # init directed graph by loading data from file
    # graph structure example:

    # {
    #  node1 <= {node2 => cost, node3 => cost},
    #  node2 <= {node1 => cost, node5 => cost}, ...
    # }

    @graph = {}
    @coordinates = []
    load_data filedata

    puts "Coordinates length: #{@coordinates.length}"
    puts "\nCoordinates: #{@coordinates.inspect}"
    puts "\nGraph: #{@graph.inspect}"

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(" ").map(&:to_f)
        if line.length == 1
          # @num_vertices = line[0]
          # @num_edges = line[1]
          next
        else
          @coordinates << line
        end
      end
    end
    for i in 0..(@coordinates.length - 1)
      for j in (i + 1)..(@coordinates.length - 1)
        edge = Math.sqrt((@coordinates[i][0] - @coordinates[j][0]) ** 2 + (@coordinates[i][1] - @coordinates[j][1]) ** 2)
        @graph[i + 1] = Hash.new if !@graph[i + 1]
        @graph[j + 1] = Hash.new if !@graph[j + 1]
        @graph[i + 1][j + 1] = edge
        @graph[j + 1][i + 1] = edge
      end
    end
  end

end

###########################################################################################################################

input_file = 'tsp.txt'
# input_file = 'testArray.txt'

solution = TSP.new(input_file)

# puts "\n---------------------------------------------------------------------------"
# puts "The minimum cost of a traveling salesman tour for the given instance #{solution.}"
# puts "---------------------------------------------------------------------------\n"

