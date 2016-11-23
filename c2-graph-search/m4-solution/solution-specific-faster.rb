# 2-SUM Algorithm

# The task is to compute the number of target values t in the interval [-10000,10000] (inclusive) 
# such that there are distinct numbers x,y in the input file that satisfy x+y=t. 
# (NOTE: ensuring distinctness requires a one-line addition to the algorithm from lecture.)


###########################################################################################################################

class TwoSum

  attr_reader :number_of_values, :distinct_targets

  def initialize(filedata)
    @hash1 = {}
    @hash2 = {}
    @distinct_targets = {}

    @number_of_values = 0

    # initialize data from file
    load_data filedata
    l = @hash2.length

    # File.open("output_spec.txt", 'w') do |f|

      @hash1.each_with_index do |(key, value), index|

        x = -10000 - key
        y = 10000 - key

        x.upto(y) do |i| 
          if @hash2.key?(i)
            @number_of_values += 1
            percentage = ((index * 100).to_f / l.to_f).round(2)
            t = key + i
            @distinct_targets[t] = true if !@distinct_targets.key?(t)
            puts "[#{percentage}\% done]\t#{key} + #{i} =\t#{t}\tNUM = #{@number_of_values}\t[#{@distinct_targets.length}]"
            # f.puts "#{key}\t#{i}\t#{key + i}\t#{@distinct_targets.length}"
          end
        end
      end

    # end

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

puts "\n--------------------------------------------------------------------"
puts "The number of target values t in the interval [-10000,10000]: #{solution.number_of_values}"
puts "The number of distinct target values t: #{solution.distinct_targets.length}"
puts "--------------------------------------------------------------------\n"
