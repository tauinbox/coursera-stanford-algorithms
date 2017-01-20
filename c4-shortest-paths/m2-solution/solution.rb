# Travelling salesman problem (TSP)

# Compute the minimum cost of a traveling salesman tour for the given instance, rounded down to the nearest integer

###########################################################################################################################

class TSP

  attr_reader :number_of_cities, :coordinates, :tsp_tour

  def initialize(filedata)

    # init undirected graph by loading data from file
    # graph structure example:

    # {
    #  node1 => {node2 => cost, node3 => cost},
    #  node2 => {node1 => cost, node5 => cost}, ...
    # }

    @graph = {}

    # subsets weights storage for dynamic programming calculations
    @a = {}

    # coordinates data read from input file
    @coordinates = []

    # array for all subsets
    all_subsets = []

    # load data and calculate the main graph
    load_data filedata

    # simple test graph which minimum cost weight from 1 through all other vertices is 13
    # @graph = {
    #   1=>{2=>2, 4=>3, 3=>1},
    #   2=>{1=>2, 3=>4, 4=>5},
    #   3=>{1=>1, 2=>4, 4=>6},
    #   4=>{3=>6, 1=>3, 2=>5}
    # }

    # puts @number_of_cities

    puts "\nCoordinates number: #{@coordinates.length}"
    puts "\nCoordinates: #{@coordinates.inspect}"
    puts "\nInput graph: #{@graph.inspect}\n\n"

    # set the base case
    first_hop = [1]
    @a[first_hop] = {}
    @a[first_hop][1] = 0

    # generate all subsets data
    for i in 2..@graph.length + 1
      for subset in all_subsets_with_size(i - 2)
        all_subsets << [1] + subset
      end
    end

    puts "Generating's done!\n\n"

    # puts "\nAll subsets: #{all_subsets.inspect}"

    # data array for removing irrelevant data (method 1)
    # data_to_remove = [1]

    # main cycle which determines size of subsets to consider
    for m in 2..@graph.length

      # data array for removing irrelevant data (method 1)
      # subsets_per_round = []

      puts "Passing through subsets with length #{m}..."

      # consider each subset from all subsets
      for subset in all_subsets

        # take only those which length is equal to m
        next if subset.length < m
        break if subset.length > m

        # fill the data array for removing irrelevant data (method 1)
        # subsets_per_round << subset

        for j in subset
          if j != 1

            # get subset without j in it
            subset_without_j = subset - [j]

            # puts "\n------- Lets j = #{j}, Subset: #{subset}, Subset without j: #{subset_without_j.inspect}\n\n"

            # array for choosing minimum
            array_to_choose_min = []

            # iterate through each k in subset and calculate paths from 1 to j in current subset
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

            # choose the minimum such path
            @a[subset][j] = array_to_choose_min.min
            # puts "Chosen minimum: #{@a[subset][j]}"
          end
        end

      end

      # clean up hash by removing irrelevant data (method 1)

      # puts "Data to remove: #{data_to_remove}"

      # @a.delete(data_to_remove) if data_to_remove == [1]

      # data_to_remove.each { |set_to_purge| @a.delete(set_to_purge) }

      # # puts "\nThis round A: #{@a}\n\nSubsets: #{subsets_per_round.inspect}\n\n"
      # data_to_remove = subsets_per_round

      # clean up hash by removing irrelevant data (method 2)
      @a.delete_if { |k, v| v.length == (m - 2) }

      # puts "\nThis round A: #{@a}\n\n"
    end

    # get the last set of calculated data where we already know the shortest paths from 1 to each other using all vertices in graph
    last_set = @a.values.last.clone
    puts "\nlast set in A: #{last_set}"

    array_to_choose_min = []

    last_set.each do |k, v|
      next if k == 1
      array_to_choose_min << v + @graph[k][1]
    end

    # choose the minimum one which completes the tour from 1 to 1 through all vertices
    @tsp_tour = array_to_choose_min.min
  end

  # method for generating all possible combinations for a given set with a given size
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
          @number_of_cities = line[0].to_i
          next
        else
          @coordinates << line if line.length > 0
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

solution = TSP.new(input_file)

puts "\n-------------------------------------------------------------------------------------------------"
puts "The minimum cost of a traveling salesman tour for the given instance (rounded to low int): #{solution.tsp_tour.to_i}"
puts "-------------------------------------------------------------------------------------------------\n"

