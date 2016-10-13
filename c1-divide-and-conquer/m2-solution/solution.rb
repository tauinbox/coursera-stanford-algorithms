@a = []
@inversion = 0

def load_data(filename)
  if File.exist? filename
    File.foreach (filename) do |line|
      @a << line.chomp.to_i
    end
  end
end

# load_data 'IntegerArray.txt'
load_data 'TestArray.txt'

def sort_and_count(a)

  n = a.length
  return a if n == 1

  middle = (n.to_f/2).ceil


  left_half = a[0...middle]
  right_half = a[(middle)...n]

  puts "______________________________________________________________"
  puts("left: #{left_half}")
  puts("right: #{right_half}")
  puts "______________________________________________________________"

  b = []
  c = []
  d = []

  b = sort_and_count(left_half)
  c = sort_and_count(right_half)

  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> b is: #{b}"
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> c is: #{c}"

  out = []
  i = 0
  j = 0

  b_empty, c_empty = false

  n.times do
    puts
    puts "left_half is #{left_half}, right_half is #{right_half}"

    puts "i = #{i}, j = #{j}, n = #{n}"
    puts

    puts "b[#{i}] = #{b[i]}, c[#{j}] = #{c[j]}"
    puts

    puts "b.length: #{b.length}"
    puts "c.length: #{c.length}"
    puts

    if !b_empty && !c_empty

      if (b[i] <= c[j])
        out << b[i]
        puts "=== b < c === put #{b[i]} to out, out is #{out}"
        i += 1
        if (b.length - i) == 0
          b_empty = true
          puts "b is empty"
        end
      else
        out << c[j]
        puts "=== c < b === inversion detected! put #{c[j]} to out, out is #{out}"
        @inversion += 1

        (i+1).upto(b.length - 1) do |index|
          if b[index] > c[j]
            puts "============= split inversion detected !!!"
            @inversion += 1
          end
        end

        j += 1
        if (c.length - j) == 0
          c_empty = true
          puts "c is empty"
        end
      end

    elsif b_empty
      out << c[j]
      puts "b is already empty, geting #{c[j]} from c, out is #{out}"
      j += 1
      if (c.length - j) == 0
        c_empty = true
        puts "c is empty"
      end
    elsif c_empty
      out << b[i]
      puts "c is already empty, getting #{b[i]} from b, out is #{out}"      
      i += 1
      if (b.length - i) == 0
        b_empty = true
        puts "b is empty"
      end
    end

  end

  puts("++++++++++++++++++++ out: #{out} ++++++++++++++++++++")

  return out

end

# puts "++++++++++++++++++++ #{sort_and_count(@a)} +++++++++++++++++"
sort_and_count(@a)
puts @inversion