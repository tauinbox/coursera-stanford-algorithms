# Dijkstra's Shortest-Path Algorithm

# Report the shortest-path distances to the following ten vertices, in order: 7,37,59,82,99,115,133,165,188,197

###########################################################################################################################

class Dijkstra

  attr_reader :distances

  def initialize(filedata)

    # init graph by loading data from file
    @a = load_data filedata

    puts @a.inspect

  end

  # Method for loading an array of data from file
  def load_data(filename)
    a = {}

    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(/\t/)
        data = line[1..line.length].map {|pair| [pair.split(',')[0].to_i, pair.split(',')[1].to_i]}
        a[line[0].to_i] = Hash[data]

      end
    end

    return a
  end


end

###########################################################################################################################

# input_file = 'dijkstraData.txt'
input_file = 'testArray.txt'

solution = Dijkstra.new(input_file)

# puts "\n----------------------------------------------------------------------"
# puts "\nDistances to the given ten vertices: #{solution.distances}"
# puts "----------------------------------------------------------------------\n"
