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
    puts @a.length

    dfs_loop(true)

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
    new_vertices.each do |data|
      @a[data[0]] = data[1]
    end
  end

  def dfs_loop(reverse_flag)
    @order = {}
    @a.length.downto(1) do |n|
      puts "\ns-VERTEX is #{n}"
      # gets
      if !(@a[n][2])
        puts "let's explore this one"
        dfs(n, reverse_flag)
      else
        puts "skip from list. we've already been there (#{n})"
      end
      puts "done! go to the next vertex in list"
    end

    puts @order.inspect
  end

  def dfs(node, reverse_flag)
    route = []
    # mark node as explored
    @a[node][2] = true
    # remember the origin
    # @s = node

    puts "now we are in #{node}"

    # put this node to stack
    route << node

    arches = reverse_flag ? 1 : 0

    # main cycle through stack
    while route.length > 0
      puts "looking for neighbours for #{route.last}"

      chosen = choose_unexplored_neighbour(route.last, arches)

      if !chosen
        puts "nothing found there, backtrace"

        @t += 1
        puts "node = #{route.last}, t = #{@t}"
        # add to order list
        @order[route.last] = @t

        route.pop
      else
        puts "we found #{chosen}, go deeper!\n\r"
        route << chosen
      end

    end

  end

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


end

###########################################################################################################################

# input_file = 'SCC.txt'
input_file = 'testArray.txt'

result = SCC.new(input_file)

# puts "\n-----------------------------------------------------------"

# puts "-----------------------------------------------------------\n"
