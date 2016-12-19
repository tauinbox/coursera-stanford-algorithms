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

    # processing
    puts "A:\n#{@a.inspect}"

    puts "A[0, 6] = #{get_val(0, 6)[0]}"

  end

  def put_val(i, x, val)
    check = get_val(i, x - 1)
    if check[0] == val
      @a[check[1]] = [@a[check[1]][0], @a[check[1]][1], @a[check[1]][2] += 1]
    else
      set_val(i, val, 1)
    end
  end

  # set recurring value
  def set_val(i, val, num_of_iterations)
    @a[i] = Array.new if !@a[i]
    if @a[i].length == 0
      start_index = 0
    else
      last = @a[i].last
      start_index = last[1] + last[2]
    end
    @a[i] << [val, start_index, num_of_iterations]
  end

  def get_val(i, x)
    @a[i].each_with_index do |dataset, idx|
      if x >= dataset[1] && x < dataset[1] + dataset[2]
        # format [found_value, index in @a]
        return [dataset[0], idx]
      else
        return false
      end
    end
  end

  def processing
    # initialize first column A[0][x] = 0 for x = 0, 1, ..., W (knapsack_size)
    set_val(0, 0, @knapsack_size + 1)

    for i in(1..@number_of_items)
      # puts "Ckeck #{i}-st item: value = #{@items[i - 1][0]}, weight = #{@items[i - 1][1]}"



      for x in(0..@knapsack_size)
        # puts "consider X = #{x}"
        @a[i] = Array.new if !@a[i]
        if @items[i - 1][1] > x

          puts "[not enough space] have #{x}, trying to put item #{i - 1} with weight #{@items[i - 1][1]}, leave previous: #{@a[i - 1][x]}"
          @a[i][x] = @a[i - 1][x]

        else

          # choose Max between A[i - 1, x] and A[i - 1, x - wi] + vi
          chosen_max = [@a[i - 1][x], @a[i - 1][x - @items[i - 1][1]] + @items[i - 1][0]].max
          @a[i][x] = chosen_max
          # puts "Chosen value: #{chosen_max}"          

        end
        # puts "-------"
        # gets
      end




    end
    # output result value
    @max_value = @a.last.last
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

# input_file = 'knapsack1.txt'
input_file = 'testArray.txt'

solution = Knapsack.new(input_file)

puts "\n-------------------------------------------------"
puts "Sum of the most valuable items put into knapsack\n\n"
puts "1. The value of the optimal solution is: #{solution.max_value}"
puts "-------------------------------------------------\n"
