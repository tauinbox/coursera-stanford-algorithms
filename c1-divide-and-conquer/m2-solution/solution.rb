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

  puts("left: #{left_half}")
  puts("right: #{right_half}")

  b = [[], 0]
  c = [[], 0]
  d = [[], 0]

  b = sort_and_count(left_half)
  c = sort_and_count(right_half)

  puts "-------------------------------------------------------------- b is: #{b}"
  puts "-------------------------------------------------------------- c is: #{c}"

  out = [[], 0]
  i = 0
  j = 0

  b_empty, c_empty = false

  n.times do

    puts "b[#{i}] = #{b[0][i]}"
    puts "c[#{j}] = #{c[0][j]}"

    puts "i: #{i}, n: #{n}"
    puts "j: #{j}, n: #{n}"

    puts "b.length: #{b[0].length}"
    puts "c.length: #{c[0].length}"

    if !b_empty && !c_empty

      if (b[0][i] <= c[0][j])
        out[0] << b[0][i]
        puts "=== b < c === put #{b[0][i]} to out"
        i += 1
        if (b[0].length - i) == 0
          b_empty = true
          puts "b is empty"
        end
      else
        out[0] << c[0][j]
        puts "=== c < b === inversion detected! put #{c[0][j]} to out"
        out[1] += 1
        @inversion += 1
        j += 1
        if (c[0].length - j) == 0
          c_empty = true
          puts "c is empty"
        end
      end

    elsif b_empty
      puts "b is already empty, get from c"
      out[0] << c[0][j]
      j += 1
      if (c[0].length - j) == 0
        c_empty = true
        puts "c is empty"
      end
    elsif c_empty
      puts "c is already empty, get from b"
      out[0] << b[0][i]
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