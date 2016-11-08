# Kosaraju's Two-Pass Algorithm

# Calculating the strongly connected components (SCCs) 
# Output the sizes of the 5 largest SCCs

###########################################################################################################################

class SCC

  attr_reader :mincut

  def initialize(filedata)
    @a = load_data filedata
    # pp @a
    # puts @a["875714"].inspect
    # puts @a.inspect
    puts @a.length
    populate_inbound_archs
    puts
    puts @a.length

    # @a.each do |key|
    #   puts key
    # end

    # puts @a["875714"].inspect
    # puts @a["4"].inspect
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


end

###########################################################################################################################

# input_file = 'SCC.txt'
input_file = 'testArray.txt'

result = SCC.new(input_file)

# puts "\n-----------------------------------------------------------"

# puts "-----------------------------------------------------------\n"
