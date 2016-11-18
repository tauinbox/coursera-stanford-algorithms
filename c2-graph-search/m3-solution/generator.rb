data = Array(1..100)

File.open("testArray.txt", 'w') do |f|
  data.length.times do
    index = rand(0..(data.length - 1))
    f.puts(data.slice!(index))
  end
end