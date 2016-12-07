# Prim's minimum spanning tree algorithm.

# Report the overall cost of a minimum spanning tree

###########################################################################################################################

class Prims

  attr_reader :x, :t, :num_edges, :num_vertices, :cost

  def initialize(filedata)

    # init graph by loading data from file
    @graph = {}
    load_data filedata
    # puts @graph.inspect
    puts @graph.length

    # explored verices data with boolean frontier attribute
    @x = {}

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
          data1 = [line[0], line[2]]
          data2 = [line[1], line[2]]
          @graph[line[0]] = Array.new if !@graph[line[0]]
          @graph[line[1]] = Array.new if !@graph[line[1]]
          @graph[line[0]] << data2
          @graph[line[1]] << data1
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
        # @a[node] - already calculated distance to node      

        # Dijkstra's greedy criterion
        selector[node] = @a[node] + nearest[1]

        # link between tail and head (edge)
        link[node] = nearest[0]

        # puts "\nfound one: #{nearest}, overall: #{selector.inspect}"
        # puts "edge: #{node} - #{nearest[0]}, length = #{@a[node]} + #{nearest[1]} = #{@a[node] + nearest[1]}\n\r"
      else
        # puts "Can't find any outter neighbours for #{node}"
      end
    end

    # greedy search result (take one with minimum distance to starting point 's')
    result = selector.min_by{|k, v| v}

    if result
      # puts "result is #{result}, let's add it to @x"
      # puts "draw the route from: #{result[0]} to #{link[result[0]]} with length #{result[1]}"

      # add result to @x
      @x[link[result[0]]] = true

      # push result distance
      @a[link[result[0]]] = result[1]

      # push result path
      @b[link[result[0]]] = @b[result[0]] + [link[result[0]]]

      # puts "\nadded result for #{link[result[0]]}, a = #{@a[link[result[0]]]}\n\r"
      # puts "\npath for #{link[result[0]]}, @b = #{@b[link[result[0]]]}\n\r"

      # update frontier attribute
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

# puts "\nShortest paths data:\nA(s) = #{solution.a}"

puts "\n-------------------------------------------------"
puts "The overall cost of a minimum spanning tree:\n#{solution.cost}"
puts "-------------------------------------------------\n"
