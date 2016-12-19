# Knapsack Algorithm

# Calculate the value of the optimal solution

###########################################################################################################################

class Knapsack

  attr_reader :knapsack_size, :number_of_items, :max_value

  def initialize(filedata)
    @items = []
    @a = []

    load_data filedata

    puts "\nKnapsack sise: #{@knapsack_size}, Total number of items: #{@number_of_items}"
    puts "\nItems:\n\n#{@items.inspect}"

    # initialize first column A[0][x] = 0 for x = 0, 1, ..., W (knapsack_size)
    @a[0] = Array.new if !@a[0]
    0.upto(@knapsack_size) { |x| @a[0][x] = 0 }

    # puts "A:\n#{@a.inspect}"
    # puts "A length:\n#{@a[0].length}"

    for i in(1..@number_of_items)
      # puts "Ckeck #{i}-st item: value = #{@items[i - 1][0]}, weight = #{@items[i - 1][1]}"
      for x in(0..@knapsack_size)
        # puts "consider X = #{x}"
        @a[i] = Array.new if !@a[i]
        if @items[i - 1][1] > x
          # puts "[not enough space] have #{x}, trying to put item #{i - 1} with weight #{@items[i - 1][1]}, leave previous: #{@a[i - 1][x]}"
          @a[i][x] = @a[i - 1][x]
        else
          chosen_max = [@a[i - 1][x], @a[i - 1][x - @items[i - 1][1]] + @items[i - 1][0]].max
          @a[i][x] = chosen_max
          # puts "Chosen value: #{chosen_max}"          
        end
        # puts "-------"
        # gets
      end
    end

    puts "Answer: #{@a.last.last}"
    # puts "A:\n#{@a.inspect}"

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
