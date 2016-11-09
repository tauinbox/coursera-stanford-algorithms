# Kosaraju's Two-Pass Algorithm

# Calculating the strongly connected components (SCCs) 
# Output the sizes of the 5 largest SCCs

###########################################################################################################################

class SCC

  # attr_reader :mincut

  def initialize(filedata)

    @t = 0
    @s = nil    

    # part 1 ---------------------------------
    # full length must be 875714

    @a = load_data filedata

    populate_inbound_archs

    # puts @a.length

    save_original
    save_reversed

    puts "forward and reverse graphs have created\n\r"

    # part 2 ---------------------------------
    # full length must be 875714
    # {10=>1, 3=>2, 5=>3, 2=>4, 8=>5, 6=>6, 9=>7, 1=>8, 4=>9, 7=>10}

    @a = {}
    GC.start

    load_data2 '_reversed.txt'

    # puts @a.length

    dfs_loop

    # end ------------------------------------    

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

  def load_data2(filename)

    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(' ').map(&:to_i)
        # puts line.inspect
        # puts line[0]
        @a[line[0]] = Array.new if !@a[line[0]]
        @a[line[0]][0] = Array.new if !@a[line[0]][0]
        @a[line[0]][0] = line[1..line.length - 1]
        @a[line[0]][1] = false
      end
    end

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

  def save_reversed
    File.open("_reversed.txt", 'w') do |f|
      @a.each do |k, v|
        # f.puts "#{k} #{v[1].join(" ")}" if v[1].length > 0
        f.puts "#{k} #{v[1].join(" ")}"
      end
    end
  end

  def save_original
    File.open("_original.txt", 'w') do |f|
      @a.each do |k, v|
        # f.puts "#{k} #{v[0].join(" ")}" if v[0].length > 0
        f.puts "#{k} #{v[0].join(" ")}"
      end
    end
  end  

  def dfs_loop
    @order = {}
    @a.length.downto(1) do |n|
      # puts "\ns-VERTEX is #{n}"
      # gets
      if !(@a[n][1])
        # puts "let's explore this one"
        dfs(n)
      else
        # puts "skip from list. we've already been there (#{n})"
      end
      # puts "done! go to the next vertex in list"
    end

    puts @order.inspect
  end

  def dfs(node)
    # mark node as explored
    @a[node][1] = true
    # remember the origin
    # @s = node

    # puts "now we are in #{node}"

    @a[node][0].each do |hop|
      # puts "looking at neighbours for #{node}, current: #{hop}"
      # check for exploring flag
      if !@a[hop][1]
        # puts "go deeper!\n\r"
        dfs(hop)
        # puts "\n...backtrace to #{node}\n\r"
      else
        # puts "have already been there (#{hop})"
      end
    end

    @t += 1
    # puts "node = #{node}, t = #{@t}"
    @order[node] = @t

  end


end

###########################################################################################################################

# input_file = 'SCC.txt'
input_file = 'testArray.txt'

result = SCC.new(input_file)

# puts "\n-----------------------------------------------------------"

# puts "-----------------------------------------------------------\n"
