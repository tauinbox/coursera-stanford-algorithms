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
  return [a, 0] if n == 1

  middle = (n.to_f/2).ceil


  left_half = a[0...middle]
  right_half = a[(middle)...n]

  puts "______________________________________________________________"
  puts("left: #{left_half}")
  puts("right: #{right_half}")
  puts "______________________________________________________________"

  b = [[], 0]
  c = [[], 0]
  d = [[], 0]

  b = sort_and_count(left_half)
  c = sort_and_count(right_half)

  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> b is: #{b}"
  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> c is: #{c}"

  out = [[], 0]
  i = 0
  j = 0

  b_empty, c_empty = false

  n.times do
    puts
    puts "left_half is #{left_half}, right_half is #{right_half}"

    puts "i = #{i}, j = #{j}, n = #{n}"
    puts

    puts "b[#{i}] = #{b[0][i]}, c[#{j}] = #{c[0][j]}"
    puts

    puts "b.length: #{b[0].length}"
    puts "c.length: #{c[0].length}"
    puts

    if !b_empty && !c_empty

      if (b[0][i] <= c[0][j])
        out[0] << b[0][i]
        puts "=== b < c === put #{b[0][i]} to out, out is #{out[0]}"
        i += 1
        if (b[0].length - i) == 0
          b_empty = true
          puts "b is empty"
        end
      else
        out[0] << c[0][j]
        puts "=== c < b === inversion detected! put #{c[0][j]} to out, out is #{out[0]}"
        out[1] += 1
        @inversion += 1

        (i+1).upto(b[0].length - 1) do |index|
          if b[0][index] > c[0][j]
            puts "Another inversion detected !!!"
            out[1] += 1
            @inversion += 1
          end
        end

        j += 1
        if (c[0].length - j) == 0
          c_empty = true
          puts "c is empty"
        end
      end

    elsif b_empty
      out[0] << c[0][j]
      puts "b is already empty, geting #{c[0][j]} from c, out is #{out[0]}"
      j += 1
      if (c[0].length - j) == 0
        c_empty = true
        puts "c is empty"
      end
    elsif c_empty
      out[0] << b[0][i]
      puts "c is already empty, getting #{b[0][i]} from b, out is #{out[0]}"      
      i += 1
      if (b[0].length - i) == 0
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