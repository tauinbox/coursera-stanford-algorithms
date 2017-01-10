# Bellman-Ford shortest-path algorithm. All-pairs shortest path calculation

# Compute the "shortest shortest path"

###########################################################################################################################

class APSP

  attr_reader :num_edges, :num_vertices, :most_shortest_length

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
    puts @graph.length

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
          # create subhash if not exists
          @graph[line[0]] = Hash.new if !@graph[line[0]]
          # populate it with cost values
          @graph[line[0]][line[1]] = line[2]
        end
      end
    end
  end

end

###########################################################################################################################

input_file = 'g1.txt'
# input_file = 'testArray.txt'

solution = APSP.new(input_file)

# puts "\n--------------------------------------------------------------------"
# puts " The most shortest path length: #{solution.most_shortest_length}"
# puts "--------------------------------------------------------------------\n"
