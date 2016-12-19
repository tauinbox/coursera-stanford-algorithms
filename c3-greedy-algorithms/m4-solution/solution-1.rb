# Knapsack Algorithm

# Calculate the value of the optimal solution

###########################################################################################################################

class Knapsack

  attr_reader :knapsack_size, :number_of_items, :max_value

  def initialize(filedata)
    @items = []

    load_data filedata

    puts "\nItems:\n\n#{@items.inspect}"

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      line_num = 0
      File.foreach (filename) do |line|
        line_num += 1
        line = line.chomp.split(' ')
        if line_num == 1
          @knapsack_size = line[0].to_i
          @number_of_items = line[1].to_i
        else
          @items << [line[0].to_i, line[1].to_i]
        end
      end
    end
  end

end

###########################################################################################################################

input_file = 'knapsack1.txt'
# input_file = 'testArray.txt'

solution = Knapsack.new(input_file)

puts "\n-----------------------------------------------------------------------"
puts "1. The value of the optimal solution is: #{solution.max_value}"
puts "-----------------------------------------------------------------------\n"
