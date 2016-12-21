# Knapsack Algorithm

# Calculate the value of the optimal solution

# More correct and fast implementation using compressed data structure (all repeating values stores in array as [value, start_index, number_of_repeats])

###########################################################################################################################

class Knapsack

  attr_reader :knapsack_size, :number_of_items, :max_value

  def initialize(filedata)
    @items = []
    @a = []

    load_data filedata

    # puts "\nKnapsack sise: #{@knapsack_size}, Total number of items: #{@number_of_items}"
    # puts "\nItems:\n\n#{@items.inspect}"

    processing
    # puts "A:\n#{@a.inspect}"

  end

  # set value into compressed array
  def set_val(i, val, num_of_iterations)

    # used if value we're trying to put into is already exist and we just need to increment its number counter
    increment = false

    @a[i] = Array.new if !@a[i]
    if @a[i].length == 0
      start_index = 0
    else
      last_item = @a[i].last
      start_index = last_item[1] + last_item[2]
      increment = true if val == last_item[0]
    end

    if increment
      @a[i].last[2] += num_of_iterations
      # puts "record already exists, just increment it, #{@a[i].length}, #{@a[i].last[0]}"
    else
      # puts "add a new record"
      @a[i] << [val, start_index, num_of_iterations]
    end
  end

  # get value from our compressed data structure by indices
  def get_val(i, x)
    # puts "\n[searching] search for i: #{i}, x: #{x}"
    @a[i].each do |dataset|
      if x >= dataset[1] && x < (dataset[1] + dataset[2])
        # puts "[GET VALUE] Found A[#{i}, #{x}] = #{dataset[0]}  (from #{dataset[1]} to #{dataset[1] + dataset[2]})"
        return dataset[0]
      end
    end
    puts "[searching] ERROR. NOTHING FOUND"
    return false
  end

  # get number of remained interations of value from its position i, x
  def get_iterations(i, x)
    # puts "\n[searching] search for i: #{i}, x: #{x}"
    @a[i].each do |dataset|
      if x >= dataset[1] && x < (dataset[1] + dataset[2])
        # get number of iterations from x-position
        return dataset[1] + dataset[2] - x
      end
    end
    puts "[searching] ERROR. NOTHING FOUND"
    return false    
  end

  def processing
    # initialize first column A[0][x] = 0 for x = 0, 1, ..., W (knapsack_size)
    set_val(0, 0, @knapsack_size + 1)

    # loop through all items
    for i in(1..@number_of_items)
      
      current_item_size = @items[i - 1][1]
      already_filled = 0

      @a[i - 1].each do |item|

        # puts "\n*****************************************************************\nLooking at previous A[#{i - 1}]: #{item}, current item size: #{current_item_size}"

        # populate recurring previous values in order to current item size

        previous_item_value = item[0]
        previous_repetition_size = item[2]

        if previous_repetition_size >= (current_item_size - already_filled)
          repeat_number = current_item_size - already_filled
          set_val(i, previous_item_value, repeat_number)
          # puts "Populate a[#{i}] with value #{previous_item_value} (#{repeat_number} times)\n\n"
          # puts "\nnow A:\n#{@a.inspect}"
          break
        else
          already_filled += item[2]
          repeat_number = item[2]
          set_val(i, previous_item_value, repeat_number)
          # puts "Populate a[#{i}] with value #{previous_item_value} (#{repeat_number} times)\n\n"
          # puts "\nnow A:\n#{@a.inspect}"          
        end

      end

      # loop while the end of capacity
      while @a[i].last[1] + @a[i].last[2] <= @knapsack_size
        current_index = @a[i].last[1] + @a[i].last[2]

        # choose Max between A[i - 1, x] and A[i - 1, x - wi] + vi
        one_way = get_val(i - 1, current_index)
        one_way_flag = true if @items[i - 1][1] > current_index
        another_way = get_val(i - 1, current_index -  @items[i - 1][1]) + @items[i - 1][0] if !one_way_flag

        # puts "\ncurrent_index = #{current_index}\n\n[ONE WAY]: #{one_way}\n[ANOTHER WAY]: #{another_way}" if !one_way_flag
        # puts "\n[ONLY WAY]: A[#{i - 1}, #{current_index}] #{one_way}" if one_way_flag

        chosen_max = one_way_flag ? one_way : [one_way, another_way].max

        # reset flag
        one_way_flag = false

        # choose which of two iterations is smaller
        iterations1 = get_iterations(i - 1, current_index)
        iterations2 = get_iterations(i - 1, current_index - @items[i - 1][1])
        min_iterations = [iterations1, iterations2].min

        # puts "\nChosen value: #{chosen_max}, put it to A!"
        # puts "Number of previous iterations A[i - 1, x]: #{iterations1}"
        # puts "Number of previous iterations A[i - 1, x - wi]: #{iterations2}"
        # puts "Total repetitions: #{min_iterations}"

        # set repetitive value
        set_val(i, chosen_max, min_iterations)

        # puts "\nA[#{i}]:\n#{@a[i].inspect}"
        # puts "i: #{i}, used space: #{@a[i].last[1] + @a[i].last[2] - 1} of #{@knapsack_size}"
        # puts "-------"
        # gets
      end
      # puts "*************************************************************************************"
      # puts "Item value: #{@items[i - 1][0]}, weight: #{@items[i - 1][1]}"
      # puts "\nA[#{i}], length #{@a[i].length}:\n#{@a[i].inspect}"
      # print (@a[i].last[0].to_s + ' ')
    end
    # output result value
    @max_value = @a.last.last[0]
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

input_file = 'knapsack_big.txt'
# input_file = 'knapsack1.txt'
# input_file = 'testArray.txt'

solution = Knapsack.new(input_file)

puts "\n-------------------------------------------------"
puts "Sum of the most valuable items put into knapsack\n\n"
puts "2. The value of optimal solution is: #{solution.max_value}"
puts "-------------------------------------------------\n"
