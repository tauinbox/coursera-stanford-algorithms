# RANDOMIZED CONTRACTION ALGORITHM (Karger's algorithm)

###########################################################################################################################

# Method for loading an array of data from file

def load_data(filename)

  a = []
  row = 0

  if File.exist? filename
    File.foreach (filename) do |line|
      a[row] = line.chomp.split(/\t/)
      row += 1
    end
  end

  return a

end

###########################################################################################################################

def get_minimum_cut(a)

  # puts "A is #{a}"

  # loop until only two vertices left
  while a.length > 2 do
    # puts
    # puts "======================================================================================="
    # puts a.inspect
    # puts  
    # puts "# of nodes: #{a.length}"  
    # puts

    # choose random vertex
    vertex_index = rand(0..(a.length - 1))
    vertex = a[vertex_index][0]
    # puts "chosen vertex #{vertex_index}: #{a[vertex_index]}"

    # choose random edge
    edge = rand(1..(a[vertex_index].length - 1))
    fused_vertex = a[vertex_index][edge]
    # puts "chosen edge: #{vertex} - #{fused_vertex}"
    fused_vertex_index = nil

    # loop through all vertices and fuse the selected edge
    a.each_with_index do |node_data, node_index|

      if node_index == vertex_index

        # puts "\n found vertex node #{node_data}, removing [#{fused_vertex}] from it"
        a[node_index].delete(fused_vertex)

      elsif node_data[0] == fused_vertex

        fused_vertex_index = node_index
        # puts "\n found fused vertex node #{a[fused_vertex_index]}, removing [#{vertex}] and [#{fused_vertex}] from it"

        a[node_index].delete(vertex)
        a[node_index].delete(fused_vertex)

      else
        # replace data with new relations
        # puts "\n found other node #{node_data}, replace fused vertex [#{fused_vertex}] with new vertex [#{vertex}]"
        a[node_index].each_with_index do |node, index|

          if node == fused_vertex
            # puts "\n replace [#{node}] with [#{vertex}]"
            a[node_index][index] = vertex
            # puts "node data is #{a[node_index]}"
          end

        end      

      end

    end

    a[vertex_index] += a[fused_vertex_index]
    a.slice!(fused_vertex_index) 

    # puts "result at this iteration: #{a.inspect}"
    # gets

  end

  return a[0].length - 1

end

###########################################################################################################################

# go through 30 iterations to have high probability of correct result
def iterate(input_file, number = 30)
  cut = nil
  number.times do
    a = load_data input_file
    result = get_minimum_cut(a)
    puts result
    cut ||= result
    cut = result if result < cut
  end
  return cut
end

###########################################################################################################################

input_file = 'kargerMinCut.txt'
# input_file = 'testArray.txt'

result = iterate(input_file)

puts "\n-----------------------------------------------------------"
puts "The minimum cut is: #{result}"
puts "-----------------------------------------------------------\n"
