# Travelling salesman problem (TSP)

# Compute the minimum cost of a traveling salesman tour for the given instance, rounded down to the nearest integer

###########################################################################################################################

class TSP

  attr_reader :s_length

  def initialize(filedata)

    # init directed graph by loading data from file
    # graph structure example:

    # {
    #  node1 => {node2 => cost, node3 => cost},
    #  node2 => {node1 => cost, node5 => cost}, ...
    # }

    @graph = {}
    @a = {}
    @coordinates = []
    all_subsets = []

    load_data filedata

    @graph = {
      1=>{2=>2, 4=>3, 3=>1},
      2=>{1=>2, 3=>4, 4=>5},
      3=>{1=>1, 2=>4, 4=>6},
      4=>{3=>6, 1=>3, 2=>5}
    }

    # puts @s_length

    puts "\nCoordinates number: #{@coordinates.length}"
    puts "\nCoordinates: #{@coordinates.inspect}"
    puts "\nGraph: #{@graph.inspect}\n\n"


    # set the basecase for all sets for vertex 1

    # for i in 2..@graph.length + 1
    #   for subset in all_subsets_with_size(i - 2)
    #     set = [1] + subset

    #     @a[set] = Hash.new if !@a[set]

    #     if set == [1]
    #       @a[set][1] = 0
    #     else
    #       @a[set][1] = Float::INFINITY
    #     end        

    #   end
    # end

    first_hop = [1]
    @a[first_hop] = {}
    @a[first_hop][1] = 0

    for i in 2..@graph.length + 1
      for subset in all_subsets_with_size(i - 2)
        all_subsets << [1] + subset
      end
    end

    puts "Generating's done!\n\n"

    # puts "\nAll subsets: #{all_subsets.inspect}"

    # puts "\nA: #{@a}"
    data_to_remove = [1]

    for m in 2..@graph.length

      subsets_per_round = []

      puts "Passing through subsets with length #{m}..."

      for subset in all_subsets

        next if subset.length < m
        break if subset.length > m

        subsets_per_round << subset

        for j in subset
          if j != 1
            subset_without_j = subset - [j]

            # puts "\n------- Lets j = #{j}, Subset: #{subset}, Subset without j: #{subset_without_j.inspect}\n\n"

            array_to_choose_min = []

            for k in subset
              if k != j
                @a[subset_without_j] = Hash.new if !@a[subset_without_j]
                if @a[subset_without_j][k]
                  # puts "\nConsider k = #{k}, A#{subset_without_j}[#{k}] = #{@a[subset_without_j][k]}, distance from k to j = #{@graph[k][j]}"
                  array_to_choose_min << @a[subset_without_j][k] + @graph[k][j]
                end
              end
            end
            # puts "\nArray to choose minimum: #{array_to_choose_min.inspect}"
            @a[subset] = Hash.new if !@a[subset]
            @a[subset][j] = array_to_choose_min.min
            # puts "Chosen minimum: #{@a[subset][j]}"
          end
        end

      end
      # puts "Data to remove: #{data_to_remove}"

      @a.delete(data_to_remove) if data_to_remove == [1]

      data_to_remove.each do |set_to_purge|
        @a.delete(set_to_purge)
      end
      # puts "\nThis round A: #{@a}\n\nSubsets: #{subsets_per_round.inspect}\n\n"
      data_to_remove = subsets_per_round
    end

    last_set = @a.values.last.clone
    puts "\nlast set in A: #{last_set}"

    array_to_choose_min = []

    last_set.each do |k, v|
      next if k == 1
      array_to_choose_min << v + @graph[k][1]
    end

    result = array_to_choose_min.min

    puts "\nResult: #{result}"

  end

  def all_subsets_with_size(size)
    puts "Generating subsets with size #{size}"
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

