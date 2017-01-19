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

    # @all_subsets = []
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


    # set the basecase for all sets for vertex 1

    for i in 2..@graph.length + 1
      for subset in all_subsets_with_size(i - 2)
        set = [1] + subset

        # @all_subsets << set

        @a[set] = Hash.new if !@a[set]

        if set == [1]
          @a[set][1] = 0
        else
          @a[set][1] = Float::INFINITY
        end        

      end
    end

    # puts "All subsets: #{@all_subsets}"

    puts "\nA: #{@a}"

    for m in 2..@graph.length

      for subset in all_subsets_with_size(m - 1)

        set = [1] + subset

        # puts "Set: #{set.inspect}"

        for j in set
          if j != 1
            subset_without_j = set - [j]

            puts "\n------- Lets j = #{j}, Set: #{set}, Subset without j: #{subset_without_j.inspect}\n\n"

            array_to_choose_min = []

            for k in set
              if k != j
                puts "\nConsider k = #{k}, A#{subset_without_j}[#{k}] = #{@a[subset_without_j][k]}, distance from k to j = #{@graph[k][j]}"
                array_to_choose_min << @a[subset_without_j][k] + @graph[k][j]
              end
            end
            puts "\nArray to choose minimum: #{array_to_choose_min.inspect}"
            @a[set][j] = array_to_choose_min.min
            puts "Chosen minimum: #{@a[set][j]}"
          end
        end

      end
    end

    # array_of_paths = []

    # for j in 1..@graph.length
    #   if j == 1
    #     puts "- Skip vertex 1 (it's starting point and we should skip it)"
    #     next
    #   end

    #   for i in 1..@graph.length
    #     puts "A[#{i}][#{j}] = #{@a[i][j]}, @graph[#{j}][1] = #{@graph[j][1]}"
    #     array_of_paths << @a[i][j] + @graph[j][1] if @a[i][j]
    #   end
    # end
    # puts "Arr: #{array_of_paths}"
    # puts "TSP: #{array_of_paths.min}"

  end

  def all_subsets_with_size(size)
    set = (2..@graph.length).to_a
    set.combination(size).to_a
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

