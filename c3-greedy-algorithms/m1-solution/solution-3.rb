# Prim's minimum spanning tree algorithm.

# Report the overall cost of a minimum spanning tree

###########################################################################################################################

class Prims

  attr_reader :x, :t, :num_edges, :num_vertices, :cost

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

    # explored verices data with boolean frontier attribute
    # {node1 => frontier_attribute1, node2 => frontier_attribute2, ...}
    @x = {}
    @t = {}
    @cost = 0

    # put the vertex number 1 into X
    start_vertex = 1
    # set the frontier attrubute to true
    @x[start_vertex] = true

    search_mst

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

  def search_mst
    while @x.length < @graph.length do
      # puts "\n============================================================"
      # puts "[@x.length = #{@x.length}, @graph.length = #{@graph.length}]\n\r"
      greedy_choose_one
      # gets
    end
    # another one (last) execution when @x.length is equal to @graph.length
    greedy_choose_one
  end

  def greedy_choose_one
    # pick the frontier ones
    frontier = []

    @x.each do |key, value|
      # check for frontier boolean attribute
      if value 
        frontier << key
      end
    end

    # puts "frontier: #{frontier}"

    selector = {}
    link = {}

    frontier.each do |node|
      # puts "looking for the nearest neighbour for #{node}..."

      # find nearest for each frontier node
      nearest = get_nearest_neighbour(node)

      if nearest
        # combine all calculated distances in one selector
        # nearest[1] - distance to found vertex
        # nearest[0] - found vertex

        # hash of nearest distances from the frontier list to outer space
        # set found nearest distance from current node in loop to outer vertex
        selector[node] = nearest[1]

        # remember the link between tail and head (edge)
        link[node] = nearest[0]

        # puts "\nfound one: #{nearest}, overall: #{selector.inspect}"
      else
        # puts "Can't find any outter neighbours for #{node}"
      end
    end

    # greedy search result (take one with minimum distance to verticises in frontier list)
    result = selector.min_by{|k, v| v}

    if result
      # puts "result is #{result}, let's add it to @x"

      # add result to @x and set it up the frontier atttribute
      # link[result[0]] here will get us the vertex to which we found the result
      @x[link[result[0]]] = true

      # augment the cost value with found result
      @cost += result[1]

      # puts "Now cost is: #{@cost}"

      # update frontier attribute, set it down for all of those, whose neighbours are already in @x
      frontier.each do |node|
        if all_neighbours_in_x?(node)
          # puts "all neighbours for #{node} are already in @x"
          @x[node] = false
        end
      end

      # puts "\n@x now is: #{@x.inspect}"

    end

  end

  def get_nearest_neighbour(node)
    hash = @graph[node]

    # delete nodes which is already in x
    @x.each do |key, value|
      hash.delete(key) if hash.key?(key)
    end

    # return node with minimum cost
    hash.min_by {|k, v| v}
  end

  def all_neighbours_in_x?(node)
    done = true
    @graph[node].each do |neighbour|
      # puts "analysing #{node}, looking for neighbour #{neighbour[0]}"
      if !@x.key?(neighbour[0])
        # puts "there is no #{neighbour[0]} in @x"
        done = false
      else
        # puts "found #{neighbour[0]} in @x"
      end
    end
    # puts "\nAll neighbours are in x for #{node}!\n\r" if done
    return done
  end


end

###########################################################################################################################

input_file = 'edges.txt'
# input_file = 'testArray.txt'

solution = Prims.new(input_file)

puts "\n--------------------------------------------------------------------"
puts "3. Prim's MST. The overall cost of a minimum spanning tree: #{solution.cost}"
puts "--------------------------------------------------------------------\n"
