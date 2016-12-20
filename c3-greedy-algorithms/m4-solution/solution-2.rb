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

    processing
    # puts "A:\n#{@a.inspect}"

    # puts "A[0, 6] = #{get_val(0, 6)[0]}"

  end

  def put_val(i, val)
    if val == @a[i].last[0]
      # if val is equal to the last value then just increment its length
      @a[i].last[2] += 1
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
    puts "\n[searching] search for i: #{i}, x: #{x}"
    @a[i].each do |dataset|
      if x >= dataset[1] && x < (dataset[1] + dataset[2])
        # puts "[GET VALUE] Found A[#{i}, #{x}] = #{dataset[0]}  (from #{dataset[1]} to #{dataset[1] + dataset[2]})"
        return dataset[0]
      end
    end
    puts "[searching] NOTHING FOUND"
    return false
  end

  def processing
    # initialize first column A[0][x] = 0 for x = 0, 1, ..., W (knapsack_size)
    set_val(0, 0, @knapsack_size + 1)

    for i in(1..@number_of_items)
      # populate recurring previous values in order to current item weight
      prev_itt = @a[i - 1][0]
      current_item_size = @items[i - 1][1]
      puts "previous itterative: #{prev_itt}, current item size: #{current_item_size}"
      if current_item_size <= prev_itt[2]
        value_to_repeat = prev_itt[0]
        repeat_number = current_item_size
        set_val(i, value_to_repeat, repeat_number)
      else
        value_to_repeat = prev_itt[0]
        repeat_number = prev_itt[2]
        set_val(i, value_to_repeat, repeat_number)        
      end

      puts "\n*****************************************************************\nPopulate a[#{i}] with value #{value_to_repeat} (#{repeat_number} times)\n\n"
      puts "\nnow A:\n#{@a.inspect}"

      # loop while the end of capacity
      while @a[i].last[1] + @a[i].last[2] <= @knapsack_size
        current_index = @a[i].last[1] + @a[i].last[2]

        # choose Max between A[i - 1, x] and A[i - 1, x - wi] + vi
        one_way = get_val(i - 1, current_index)
        one_way_flag = true if @items[i - 1][1] > current_index
        another_way = get_val(i - 1, current_index -  @items[i - 1][1]) + @items[i - 1][0] if !one_way_flag

        puts "One way: A[#{i - 1}, #{current_index}] #{one_way}, Another: #{another_way}, current_index = #{current_index}"

        chosen_max = one_way_flag ? one_way : [one_way, another_way].max

        one_way_flag = false

        puts "Chosen value: #{chosen_max}, put it to A!"
        put_val(i, chosen_max)

        puts "\nnow A:\n#{@a.inspect}"

        puts "-------"
        gets
      end

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

# input_file = 'knapsack1.txt'
input_file = 'testArray.txt'

solution = Knapsack.new(input_file)

puts "\n-------------------------------------------------"
puts "Sum of the most valuable items put into knapsack\n\n"
puts "1. The value of the optimal solution is: #{solution.max_value}"
puts "-------------------------------------------------\n"
