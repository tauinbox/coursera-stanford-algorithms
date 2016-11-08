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
        line = line.chomp.split(' ')
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
      key = n.to_s
      puts "\ns-VERTEX is #{key}"
      gets
      if !(@a[key][2])
        puts "let's explore this one"
        dfs(key, reverse_flag)
      else
        puts "skip from list. we've already been there (#{key})"
      end
      puts "done! go to the next vertex in list"
    end

    puts @order.inspect
  end

  def dfs(node, reverse_flag)
    # mark node as explored
    @a[node][2] = true
    # remember the origin
    @s = node

    puts "now we are in #{node}"

    archs = reverse_flag ? 1 : 0

    @a[node][archs].each do |hop|
      puts "looking at neighbours for #{node}, current: #{hop}"
      if !@a[hop][2]
        puts "go deeper!\n\r"
        dfs(hop, reverse_flag)
        return
      else
        puts "have already been there (#{hop})"
      end
    end

    @t += 1
    puts "s = #{@s}, t = #{@t}"
    @order[@s] = @t    

  end


end

###########################################################################################################################

# input_file = 'SCC.txt'
input_file = 'testArray.txt'

result = SCC.new(input_file)

# puts "\n-----------------------------------------------------------"

# puts "-----------------------------------------------------------\n"
