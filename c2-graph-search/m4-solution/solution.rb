# 2-SUM Algorithm

# The task is to compute the number of target values t in the interval [-10000,10000] (inclusive) 
# such that there are distinct numbers x,y in the input file that satisfy x+y=t. 
# (NOTE: ensuring distinctness requires a one-line addition to the algorithm from lecture.)


###########################################################################################################################

class TwoSum

  attr_reader :number_of_values

  def initialize(filedata)
    @hash = {}
    @number_of_values = 0

    # initialize data from file
    load_data filedata

    puts @hash.length

    @hash.each_with_index do |(key,value),index|
      x = -10000 - key
      y = 10000 - key

      x.upto(y) do |i| 
        if @hash.key?(i)
          if key <= i
            @number_of_values += 1
            percentage = ((index * 100) / 999752).ceil
            puts "[Index: #{index}] Found #{key} + #{i} = #{key + i}, T = #{@number_of_values}, [#{percentage}\% done]"
          end
        end
      end
    end

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        number = line.chomp.to_i
        next if @hash.key?(number)
        @hash[number] = true
      end
    end
  end



end

###########################################################################################################################

input_file = 'algo1-programming_prob-2sum.txt'
# input_file = 'testArray.txt'

solution = TwoSum.new(input_file)

puts "\n-------------------------------------------------"
puts "The sum of given 10000 medians: #{solution.number_of_values}"
puts "-------------------------------------------------\n"
