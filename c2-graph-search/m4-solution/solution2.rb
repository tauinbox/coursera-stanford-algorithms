# 2-SUM Algorithm

# The task is to compute the number of target values t in the interval [-10000,10000] (inclusive) 
# such that there are distinct numbers x,y in the input file that satisfy x+y=t. 
# (NOTE: ensuring distinctness requires a one-line addition to the algorithm from lecture.)


###########################################################################################################################

class TwoSum

  attr_reader :number_of_values

  def initialize(filedata)
    @hash1 = {}
    @hash2 = {}

    @number_of_values = 0

    # initialize data from file
    load_data filedata

    puts "Hash1 length: #{@hash1.length}"
    puts "Hash2 length: #{@hash2.length}"

    l = @hash2.length

    @hash2.each_with_index do |(key, value), index|
      x = -10000 - key
      y = 10000 - key

      x.upto(y) do |i| 
        if @hash1.key?(i)
          @number_of_values += 1
          percentage = ((index * 100) / l).ceil
          puts "[Index: #{index}] Found #{key} + #{i} = #{key + i}, NUM = #{@number_of_values}, [#{percentage}\% done]"
        end
      end
    end

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        number = line.chomp.to_i
        next if (@hash1.key?(number) || @hash2.key?(number))
        @hash1[number] = true if number <= 0
        @hash2[number] = true if number > 0
      end
    end
  end



end

###########################################################################################################################

input_file = 'algo1-programming_prob-2sum.txt'
# input_file = 'testArray.txt'

solution = TwoSum.new(input_file)

# puts "\n-------------------------------------------------"
# puts "The number of target values t in the interval [-10000,10000]: #{solution.number_of_values}"
# puts "-------------------------------------------------\n"
