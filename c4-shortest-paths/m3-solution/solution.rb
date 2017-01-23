# A heuristic for the Travelling salesman problem (TSP)

# Compute the heuristic minimum cost of a traveling salesman tour for the given instance, rounded down to the nearest integer

###########################################################################################################################

class TSP

  attr_reader :number_of_cities, :coordinates, :tour, :tour_length

  def initialize(filedata)

    # coordinates data read from input file
    @coordinates = []

    # tour data array
    @tour = []

    # tour length
    @tour_length = 0    

    # load data and calculate the main graph
    load_data filedata

    # puts @number_of_cities

    puts "\nCoordinates number: #{@coordinates.length}"
    # puts "\nCoordinates: #{@coordinates.inspect}"

    # set first point of tour
    @tour << @coordinates.slice!(0)

    # puts "Tour: #{tour}"

    while @coordinates.length > 0 do
      # puts "Let's find the nearest hop from point #{tour.last.inspect}"
      next_hop = find_nearest(@tour.last)
      # puts "Found #{next_hop[0]} element at the distance #{next_hop[1]}, add it to our route"
      @tour << @coordinates.slice!(next_hop[0])
      @tour_length += next_hop[1]
      # puts "Tour length: #{@tour_length}\nTour: #{tour.inspect}"
      # gets
    end

    # puts "Tour: #{tour.inspect}"

    path_to_home = Math.sqrt((@tour.last[0] - @tour.first[0]) ** 2 + (@tour.last[1] - @tour.first[1]) ** 2)
    puts "Tour length: #{@tour_length}, Path to home: #{path_to_home}"
    @tour_length += path_to_home
    puts "Total length: #{@tour_length}"

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
          @coordinates << [line[1], line[2]] if line.length > 0
        end
      end
    end
  end

  def find_nearest(start_point)
    point_index = false
    minimum = false

    @coordinates.each_with_index do |end_point, index|
      length = Math.sqrt((start_point[0] - end_point[0]) ** 2 + (start_point[1] - end_point[1]) ** 2)
      minimum ||= length
      point_index ||= index

      # puts "squared_length: #{squared_length}, minimum: #{minimum}, point_index: #{point_index}"

      if length < minimum
        minimum = length
        point_index = index
      end
    end
    return [point_index, minimum]
  end

end

###########################################################################################################################

input_file = 'nn.txt'
# input_file = 'test_data.txt'

solution = TSP.new(input_file)

puts "\n------------------------------------------------------------------------------------------------------------"
puts "The heuristic minimum cost of a traveling salesman tour for the given instance (rounded to low int): #{solution.tour_length.to_i}"
puts "------------------------------------------------------------------------------------------------------------\n"

