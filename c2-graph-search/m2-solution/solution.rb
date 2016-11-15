# Dijkstra's Shortest-Path Algorithm

# Report the shortest-path distances to the following ten vertices, in order: 7,37,59,82,99,115,133,165,188,197

###########################################################################################################################

class Dijkstra

  attr_reader :distances

  def initialize(filedata)

    # init graph by loading data from file
    @graph = {}
    load_data filedata
    @x = {}
    @a = {}
    @b = {}

    # puts @graph.inspect
    # puts @graph.length

    #put first vertex into X
    start_vertex = 1
    @x[start_vertex] = true
    @a[start_vertex] = 0
    @b[start_vertex] = [start_vertex]
    # puts @x

    search_path

    puts "final result. @a = #{@a.inspect}"

    # @distances = []
    # [7,37,59,82,99,115,133,165,188,197].each do |node|
    #   @distances << @a[node]
    #   puts "\npath: #{@b[node].inspect}, length = #{@a[node]}"
    # end

    # puts
    # puts @distances.join(',')

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(/\t/)
        data = line[1..line.length].map {|pair| [pair.split(',')[0].to_i, pair.split(',')[1].to_i]}
        @graph[line[0].to_i] = Hash[data]
      end
    end
  end

  def search_path
    while @x.length < @graph.length do
      puts "\n============================================================"
      puts "[@x.length = #{@x.length}, @graph.length = #{@graph.length}]\n\r"
      greedy_choose_one
      gets
    end 
    greedy_choose_one
  end

  def greedy_choose_one
    # pick the frontier ones
    frontier = []

    @x.each do |key, value|
      if value 
        frontier << key
      end
    end

    puts "frontier: #{frontier}"

    selector = {}
    link = {}

    frontier.each do |node|
      puts "looking for the nearest neighbour for #{node}..."

      # find nearest for each frontier node
      nearest = get_nearest_neighbour(node)

      # combine all nearests in one selector

      # nearest[1] - distance
      # nearest[0] - found vertex

      if nearest
        selector[node] = nearest[1] + @a[node]

        link[node] = nearest[0]

        puts "\nfound one: #{nearest}, overall: #{selector.inspect}"
        puts "edge: #{node} - #{nearest[0]}, length = #{@a[node]} + #{nearest[1]} = #{@a[node] + nearest[1]}\n\r"
      else
        puts "Can't find any outter neighbours for #{node}"
      end
    end

    # greedy search result
    result = selector.min_by{|k, v| v}

    if result
      puts "result is #{result}, let's add it to @x"
      puts "draw the route from: #{result[0]} to #{link[result[0]]} with length #{result[1]}"

      # add result to @x
      @x[link[result[0]]] = true

      @a[link[result[0]]] = result[1]
      @b[link[result[0]]] = @b[result[0]] + [link[result[0]]]

      puts "\nadded result for #{link[result[0]]}, a = #{@a[link[result[0]]]}\n\r"
      puts "\npath for #{link[result[0]]}, @b = #{@b[link[result[0]]]}\n\r"

      frontier.each do |node|
        if all_neighbours_in_x?(node)
          puts "all neighbours for #{node} are already in @x"
          @x[node] = false
        end
      end

      puts "\n@x now is: #{@x.inspect}"

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

# input_file = 'dijkstraData.txt'
input_file = 'testArray.txt'

solution = Dijkstra.new(input_file)

# puts "\n----------------------------------------------------------------------"
# puts "\nDistances to the given ten vertices: #{solution.distances}"
# puts "----------------------------------------------------------------------\n"
