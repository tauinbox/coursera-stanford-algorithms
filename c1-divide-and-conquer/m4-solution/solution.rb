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

# input_file = 'kargerMinCut.txt'
input_file = 'testArray.txt'

a = load_data input_file

# puts "A is #{a}"
puts a.inspect
puts "# of nodes: #{a.length}"

while a.length > 2 do
  vertex = rand(0..(a.length - 1))
  puts "chosen vertex #{vertex}: #{a[vertex]}"
  edge = rand(1..(a[vertex].length - 1))
  puts "chosen edge: #{a[vertex][0]} - #{a[vertex][edge]}"
  gets
end