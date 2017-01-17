# Travelling salesman problem (TSP)

# Compute the minimum cost of a traveling salesman tour for the given instance, rounded down to the nearest integer

###########################################################################################################################

class TSP

  attr_reader :s_length

  def initialize(filedata)

    # init directed graph by loading data from file
    # graph structure example:

    # {
    #  node1 <= {node2 => cost, node3 => cost},
    #  node2 <= {node1 => cost, node5 => cost}, ...
    # }

    @graph = {}
    @a = {}
    @coordinates = []
    # load_data filedata

    @graph = {
      1=>{2=>2, 4=>3, 3=>1},
      2=>{1=>2, 3=>4, 4=>5},
      3=>{1=>1, 2=>4, 4=>6},
      4=>{3=>6, 1=>3, 2=>5}
    }

    # puts @s_length

    puts "Coordinates length: #{@coordinates.length}"
    puts "\nCoordinates: #{@coordinates.inspect}"
    puts "\nGraph: #{@graph.inspect}"


    # set the basecase ('s' has only one vertex)
    @a[1] = {}
    @a[1][1] = 0

    for m in 2..@graph.length
      for s in 1..m
        puts "\n--------------------------------------------------------\nConsider vertex #{s} from set of #{m} vertices"

        # iterate through relevant choices of j in current set s
        for j in 1..s

          # skip the start vertex (vertex 1 in this case)
          if j == 1
            puts "- Skip vertex 1 (it's starting point and can't be j)"
            next
          end

          puts "\nLets j = #{j}\n\n"

          @a[s] = Hash.new if !@a[s]
          @a[s][j] = choose_min(s, j)

          puts "\nSet A[#{s}][#{j}] = #{@a[s][j]}\nA = #{@a.inspect}"
          gets
        end
      end
    end

  end

  def choose_min(s, j)
    puts "Calculating A[#{s}][#{j}]..."
    array_to_choose_min = []

    for k in 1..s
      puts "\nLooking at vertex k = #{k} from possible set of #{s}"

      # skip if 'k' is equal to 'j'
      if k == j
        puts "Excluded! (#{k}), because it's j-vertex\n\n"
        next
      end

      puts "A[#{k}][#{k}] = #{@a[k][k]}, Edge length to 'j' = #{@graph[k][j]}"
      array_to_choose_min << @a[k][k] + @graph[k][j] if @a[k][k]
      # array_to_choose_min << (@a[s - k][k] ? @a[s - k][k] + @graph[k][j] : nil)
      puts "array: #{array_to_choose_min.inspect}"
    end

    puts "array_to_choose_min: #{array_to_choose_min.inspect}"
    return array_to_choose_min.min
  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(" ").map(&:to_f)
        if line.length == 1
          @s_length = line[0].to_i
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

