# 2SAT Problem, SCC algorithm

# Determine which of the 6 instances are satisfiable, and which are unsatisfiable. 
# In the box below, enter a 6-bit string, where the ith bit should be 1 if the ith instance is satisfiable, and 0 otherwise. 
# For example, if you think that the first 3 instances are satisfiable and the last 3 are not, then you should enter the string 111000 in the box below

###########################################################################################################################

# If you have n variables and m clauses:
# Create a graph with 2n vertices: intuitively, each vertex resembles a true or not true literal for each variable.

# For each clause (a v b), where a and b are literals, create an edge from !a to b and from !b to a. 
# These edges mean that if a is not true, then b must be true and vica-versa.

# Once this digraph is created, go through the graph and see if there is a cycle that contains both a and !a for some variable a. 
# If there is, then the 2SAT is not satisfiable (because a implies !a and vica-versa).

# Otherwise, it is satisfiable, and this can even give you a satisfying assumption (pick some literal a so that a doesn't imply !a, force all implications from there, repeat). 
# You can do this part with any of your standard graph algorithms, ala Breadth-First Search , Floyd-Warshall, 
# or any algorithm like these, depending on how sensitive you are to the time complexity of your algorithm.

class TwoSAT

  attr_reader :number_of_elements, :is_satisfied

  def initialize(filedata)

    @set_of_clauses = []
    @variables = {}
    @is_satisfied = false
    @graph = {}

    # load data
    load_data filedata

    # puts "\nnumber_of_elements: #{@number_of_elements}, set_of_clauses: #{@set_of_clauses.inspect}"

    puts "\nGraph: #{@graph.inspect}"

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
    @set_of_clauses.each do |clause|
      @graph[-clause[0]] = Array.new if !@graph[-clause[0]]
      @graph[-clause[0]] << clause[1]
      @graph[-clause[1]] = Array.new if !@graph[-clause[1]]
      @graph[-clause[1]] << clause[0]
    end
  end

end

###########################################################################################################################

# input_file = '2sat1.txt'
input_file = 'test_data_true.txt'
# input_file = 'test_data_false.txt'

solution = TwoSAT.new(input_file)

# puts "\n---------------------"
# puts "It can be satisfied!" if solution.is_satisfied
# puts "Unsatisfied... sorry" if !solution.is_satisfied
# puts "---------------------\n"

