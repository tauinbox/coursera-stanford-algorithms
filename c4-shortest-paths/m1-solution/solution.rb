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
    @a = {}
    load_data filedata
    puts @graph.inspect
    # puts @graph.length

    find_from_source(1)

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
          @graph[line[0]] = Hash.new(nil) if !@graph[line[0]]
          @graph[line[1]] = Hash.new(nil) if !@graph[line[1]]
          # populate it with cost values
          @graph[line[1]][line[0]] = line[2]
        end
      end
    end
  end

  def find_from_source(s)
    @a[0] = {}
    @a[0][s] = 0

    for i in 1..@num_vertices - 1
      puts "\ni = #{i}"
      @graph.each do |vertex|
        puts "\n----------------------------------------------\nLOOKING AT VERTEX #{vertex}"
        case1 = @a[i - 1][vertex.first]
        case2 = get_minimum_inbound_path(i, vertex.first)
        puts "case1: #{case1}, case2: #{case2}"
        @a[i] = Hash.new if !@a[i]
        @a[i][vertex.first] = case2 ? (case1 ? [case1, case2].min : case2) : case1
        puts "set A[#{i}][#{vertex.first}] to #{@a[i][vertex.first]}"
        puts "A: #{@a.inspect}"
        gets        
      end
    end
  end

  def get_minimum_inbound_path(i, vertex)
    if @graph[vertex].length > 0
      sample_edge = @graph[vertex].first
      # puts "sample_edge: #{sample_edge}"

      path_to_tail = @a[i - 1][sample_edge[0]]
      # puts "path_to_tail: #{path_to_tail}"

      if path_to_tail

        min_path = path_to_tail + sample_edge[1]
        # puts "let's set sample_edge to #{sample_edge}, min_path to #{min_path}"

        @graph[vertex].each do |inbound|
          puts "checking vertex #{inbound}"

          path_to_tail = @a[i - 1][inbound[0]]
          puts "path_to_tail (A[#{i - 1}][#{inbound[0]}]): #{path_to_tail}"

          if path_to_tail
            path = path_to_tail + inbound[1]

            if path < min_path
              puts "[path scanning] found smaller one: #{path}"
              min_path = path
            end          
          end
        end
        puts "The smallest path for vertex #{vertex} is #{min_path}"
        return min_path
      else
        return false
      end
    else
      puts "There is no one inbound arch to vertex #{vertex}"
      return false
    end
  end

end

###########################################################################################################################

# input_file = 'g1.txt'
input_file = 'testArray.txt'

solution = APSP.new(input_file)

# puts "\n--------------------------------------------------------------------"
# puts " The most shortest path length: #{solution.most_shortest_length}"
# puts "--------------------------------------------------------------------\n"
