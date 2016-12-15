# Dynamic Programming Algorithm

# Run the dynamic programming algorithm (and the reconstruction procedure) from lecture on this data set. 
# The question is: of the vertices 1, 2, 3, 4, 17, 117, 517, and 997, which ones belong to the maximum-weight independent set?

###########################################################################################################################

class Mwis

  attr_reader :number_of_vertices, :max_wis, :answer_string

  def initialize(filedata)
    @weights = []
    @a = []
    @s = {}

    load_data filedata

    # puts "\nInput data:\n\n#{@weights.inspect}"

    calculate_max_sum
    puts "\nA:\n\n#{@a.inspect}"

    reconstruct_wis
    puts "\nS:\n\n#{@s.inspect}"

  end

  def calculate_max_sum
    @a[0] = 0
    @a[1] = @weights[0]

    # puts "\nA: #{@a.inspect}\n----------------------"
    for i in(2..@weights.length - 1)
      # puts "Found max: #{[@a[i - 1], @a[i - 2] + @weights[i - 1]].max} from A[#{i - 1}] (#{@a[i - 1]}) and A[#{i - 2}] + W[#{i - 1}] = #{@a[i - 2]} + #{@weights[i - 1]} (#{@a[i - 2] + @weights[i - 1]})"
      @a[i] = [@a[i - 1], @a[i - 2] + @weights[i - 1]].max
      # puts "A[#{i}] = #{@a[i]}"
      # puts "\nA: #{@a.inspect}\n----------------------"
      # gets
    end
  end

  def reconstruct_wis
    i = @a.length
    while i >= 1 do
      if @a[i - 1] >= (@a[i - 2] + @weights[i - 1])
        # case 1 wins, last vertex is not in max-WIS (@s)
        i -= 1
      else
        # case 2 wins, last vertex is in max-WIS (@s)
        @s[i] = @weights[i - 1]
        # puts "[CASE 2] A[#{i - 1}] #{@a[i - 1]} < A[#{(i < 2 ? 2 : i) - 2}] + W[#{i - 1}] = #{@a[i - 2] + @weights[i - 1]}, put W[#{i - 1}] #{@weights[i - 1]} into S"
        i = i -= 2
        i = 0 if i < 0
      end
      # puts "i: #{i}, W[#{i}]: #{@weights[i]}, S: #{@s.inspect}"
      # gets
    end
  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      line_num = 0
      File.foreach (filename) do |line|
        line_num += 1
        line = line.chomp.to_i
        if line_num == 1
          @number_of_vertices = line 
        else
          @weights << line
        end
      end
    end
  end


end

###########################################################################################################################

input_file = 'mwis.txt'
# input_file = 'testArray2.txt'

solution = Mwis.new(input_file)

puts "\n-----------------------------------------------------------------------"
puts "Dynamic Programming Algorithm.\n\r"
puts "These ones belong to the maximum-weight independent set: #{solution.max_wis}"
puts "Answer string: #{solution.answer_string}"
puts "-----------------------------------------------------------------------\n"
