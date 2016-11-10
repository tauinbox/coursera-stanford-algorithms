# Kosaraju's Two-Pass Algorithm

# Calculating the strongly connected components (SCCs) 
# Output the sizes of the 5 largest SCCs

###########################################################################################################################

class SCC

  # attr_reader :mincut

  def initialize(filedata)
    @a = load_data filedata
    @t = 0
    @s = nil

    # puts @a.length
    populate_inbound_archs
    puts "\nThe graph has #{@a.length} vertices"

    dfs_loop(true)
    @a = replace_by_finishing_times
    GC.start
    # puts
    # puts @a.inspect
    scc_list = dfs_loop(false)
    scc_list.sort!.reverse!
    puts "\nSizes of the 5 largest SCCs in the given graph: #{scc_list[0..4].join(',')}"

  end

  # Method for loading an array of data from file
  def load_data(filename)
    a = {}

    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(' ').map(&:to_i)
        a[line[0]] = Array.new if !a[line[0]]
        a[line[0]][0] = Array.new if !a[line[0]][0]
        a[line[0]][0] << line[1]
        a[line[0]][1] = Array.new if !a[line[0]][1]
        a[line[0]][2] = false
      end
    end

    return a
  end

  #expand graph (populate list of all vertices with inbound and outbound arches)
  def populate_inbound_archs
    new_vertices = []
    @a.each do |key, value|
      value[0].each do |vertex|
        # puts vertex
        # @a[vertex].insert(1, Array.new()) if @a[vertex][1] == false
        if @a[vertex]
          @a[vertex][1] << key
          # puts @a[vertex].inspect
        else
          # puts "detected alone vertex '#{vertex}'"
          new_vertices << [vertex, [[], [key], false]]
        end
      end
    end
    # insert vertices having any inbound or outbound arches into graph hash
    new_vertices.each do |data|
      @a[data[0]] = data[1]
    end
  end

  def dfs_loop(reverse_flag)
    scc_list = []
    reverse_flag ? puts("\n... STARTING 1st PASS\n") : puts("\n... STARTING 2nd PASS\n")
    @order = {}
    @a.length.downto(1) do |n|
      # puts "\ns-VERTEX is #{n}"
      # gets
      if !(@a[n][2])
        # puts "let's explore this one"
        number_of_elements_in_route = dfs(n, reverse_flag)
        scc_list << number_of_elements_in_route if number_of_elements_in_route > 1
        # puts "\n[Leader] - #{@s}, explored #{number_of_elements_in_route} elements\n\r" if !reverse_flag
      else
        # puts "skip from list. we've already been there (#{n})"
      end
      # puts "done! go to the next vertex in list"
    end

    # puts "\nFinishing times data: \n#{@order.inspect}"
    return reverse_flag ? nil : scc_list
  end

  def dfs(node, reverse_flag)
    route = []
    # mark node as explored
    @a[node][2] = true
    # remember the origin
    @s = node
    counter = 0

    # puts "now we are in #{node}"

    # put this node to stack
    route << node

    arches = reverse_flag ? 1 : 0

    # main cycle through stack
    while route.length > 0

      # increase counter on each search
      counter += 1
      # puts "looking for neighbours for #{route.last}"

      chosen = choose_unexplored_neighbour(route.last, arches)

      if !chosen
        # puts "nothing found there, backtrace"

        # decrease counter if no unexplored element found 
        counter -= 1

        # increase @t if no unexplored element found
        @t += 1
        # puts "node = #{route.last}, t = #{@t}"
        # add to order list
        @order[route.last] = @t

        route.pop
      else
        # puts "we found #{chosen}, go deeper!\n\r"
        route << chosen
      end

    end

    # +1 because of 1st element in group which we had marked as explored on start
    return counter + 1
  end

  # arches parameter is used for choosing inbound or outbound arches (forward or reverse graph)
  def choose_unexplored_neighbour(node, arches)
    @a[node][arches].each do |vertex|
      if !@a[vertex][2]
        # mark it as explored and return
        !@a[vertex][2] = true
        return vertex
      end
    end
    # if we are here we found nothing
    return false
  end

  def replace_by_finishing_times
    result = {}
    @a.each do |key, value|
      replaced_arches = []
      value[0].each do |node|
        replaced_arches << @order[node]
      end
      result[@order[key]] = Array.new if !result[@order[key]]
      result[@order[key]][0] = Array.new if !result[@order[key]][0]
      result[@order[key]][0] = replaced_arches
      result[@order[key]][1] = Array.new if !result[@order[key]][1]
      result[@order[key]][2] = false
    end
    return result
  end

end

###########################################################################################################################

input_file = 'SCC.txt'
# input_file = 'testArray.txt'

result = SCC.new(input_file)

# puts "\n-----------------------------------------------------------"

# puts "-----------------------------------------------------------\n"
