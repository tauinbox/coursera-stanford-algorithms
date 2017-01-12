# Bellman-Ford shortest-path algorithm. All-pairs shortest path calculation

# Compute the "shortest shortest path"

###########################################################################################################################

class APSP

  attr_reader :num_edges, :num_vertices, :shortest_shortest_path, :tail, :head, :has_negative_cost_cycle

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

    @shortest_shortest_path = false
    @tail = false
    @head = false
    @has_negative_cost_cycle = false

    for i in 1..@num_vertices
      @a = {}
      path = find_from_source(i)

      if path == :negative_cycle
        @has_negative_cost_cycle = true
        break
      end

      if !path.nil?
        @shortest_shortest_path ||= path[1]
        if path[1] < @shortest_shortest_path
          @shortest_shortest_path = path[1]
          @tail = i 
          @head = path[0]
        end

        # puts "Minimum path from vertex #{i} to vertex #{path[0]} is #{path[1]}"
      end
    end

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
      # puts "\ni = #{i}"
      no_changes = scan_through_vertices(i)
      if no_changes
        # puts "\n[i = #{i}] We're done and can stop the loop!"
        break
      end
    end
    # extra check for negtive cost cycle if last iteration has changes
    if !no_changes
      no_changes_anymore = scan_through_vertices(@num_vertices)
      if !no_changes_anymore
        # puts "[negative cost cycle detected] Can't process this graph"
        return :negative_cycle
      end
    end
    result = @a.values.last.clone
    
    # remove source vertex data from hash
    result.delete(s)

    # remove all empty (nil) entries
    result.delete_if { |k, v| v.nil? }

    shortest_path = result.min_by{ |k, v| v }
    # puts "Shortest path: #{shortest_path}"

    # return @a.values.last
    return shortest_path
  end

  def scan_through_vertices(i)
    no_changes = true    
    @graph.each do |vertex|
      # puts "\n----------------------------------------------\nLOOKING AT VERTEX #{vertex}"
      case1 = @a[i - 1][vertex.first]
      case2 = get_minimum_inbound_path(i, vertex.first)
      # puts "case1: #{case1}, case2: #{case2}"
      @a[i] = Hash.new if !@a[i]
      @a[i][vertex.first] = case2 ? (case1 ? [case1, case2].min : case2) : case1
      # puts "set A[#{i}][#{vertex.first}] to #{@a[i][vertex.first]}"
      # puts "A: #{@a.inspect}"
      no_changes = false if @a[i][vertex.first] != @a[i - 1][vertex.first]
    end
    return no_changes  
  end

  def get_minimum_inbound_path(i, vertex)
    if @graph[vertex].length > 0

      min_path = false

      @graph[vertex].each do |inbound|
        # puts "checking vertex #{inbound}"

        path_to_tail = @a[i - 1][inbound[0]]
        # puts "path_to_tail (A[#{i - 1}][#{inbound[0]}]): #{path_to_tail}"

        if path_to_tail
          path = path_to_tail + inbound[1]
          min_path ||= path

          if path < min_path
            # puts "[path scanning] found smaller one: #{path}"
            min_path = path
          end          
        end
      end
      # puts "The smallest path for vertex #{vertex} is #{min_path}"
      return min_path

    else
      # puts "There is no one inbound arch to vertex #{vertex}"
      return false
    end
  end

end

###########################################################################################################################

# input_file = 'g3.txt'
input_file = 'testArray.txt'

solution = APSP.new(input_file)

if solution.has_negative_cost_cycle
  puts "\n--------------------------------------------------------------------"
  puts "Negative cost cycle detected! Can't process this graph"
  puts "--------------------------------------------------------------------\n"
else
  puts "\n---------------------------------------------------------------------------"
  puts "The shortest shortest path is from vertex #{solution.tail} to vertex #{solution.head} with value #{solution.shortest_shortest_path}"
  puts "---------------------------------------------------------------------------\n"
end
