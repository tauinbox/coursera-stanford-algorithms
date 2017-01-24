# Papadimitrou's 2SAT algorithm (too long for big data)

# Determine which of the 6 instances are satisfiable, and which are unsatisfiable. 
# In the box below, enter a 6-bit string, where the ith bit should be 1 if the ith instance is satisfiable, and 0 otherwise. 
# For example, if you think that the first 3 instances are satisfiable and the last 3 are not, then you should enter the string 111000 in the box below

###########################################################################################################################

class TwoSAT

  attr_reader :number_of_elements, :is_satisfied

  def initialize(filedata)

    @set_of_clauses = []
    @variables = {}
    @is_satisfied = false

    # load data
    load_data filedata

    # puts "\nnumber_of_elements: #{@number_of_elements}, set_of_clauses: #{@set_of_clauses.inspect}"

    iterations = Math.log(@number_of_elements, 2).ceil

    for i in 1..iterations
      puts "Pass #{i} of #{iterations}..."
      get_random_set
      (2 * @number_of_elements ** 2).times do
        result = check_clauses
        if result[0]
          # puts "It can be satisfied!"
          @is_satisfied = true
          return
        end
        var_index_to_flip = [result[1], result[2]].sample
        @variables[var_index_to_flip] = !@variables[var_index_to_flip]
      end
    end
    # puts "Unsatisfied... sorry"

  end

  # Method for loading data from file
  def load_data(filename)
    if File.exist? filename
      File.foreach (filename) do |line|
        line = line.chomp.split(" ").map(&:to_i)
        if line.length == 1
          @number_of_elements = line[0].to_i
          next
        else
          @set_of_clauses << line if line.length > 0
        end
      end
    end
  end

  # set all variables randomly
  def get_random_set
    @variables = {}
    for i in 1..@number_of_elements
      @variables[i] = [true, false].sample
    end
  end

  def check_clauses
    @set_of_clauses.each_with_index do |clause, index|
      var1_index = clause[0].abs
      var2_index = clause[1].abs
      var1 = clause[0] < 0 ? !@variables[var1_index] : @variables[var1_index]
      var2 = clause[1] < 0 ? !@variables[var2_index] : @variables[var2_index]
      return [false, var1_index, var2_index] if !(var1 || var2)
    end
    return [true]
  end

end

###########################################################################################################################

input_file = '2sat1.txt'
# input_file = 'test_data_true.txt'
# input_file = 'test_data_false.txt'

solution = TwoSAT.new(input_file)

puts "\n---------------------"
puts "It can be satisfied!" if solution.is_satisfied
puts "Unsatisfied... sorry" if !solution.is_satisfied
puts "---------------------\n"

