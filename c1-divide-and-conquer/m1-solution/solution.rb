x = 3141592653589793238462643383279502884197169399375105820974944592
y = 2718281828459045235360287471352662497757247093699959574966967627

# x = 1234
# y = 5678

# x = 123
# y = 456

# x = 12
# y = 34

# x = 46
# y = 134

def product(x, y)

  x_string = x.to_s
  y_string = y.to_s

  n = [x_string.length, y_string.length].max
  puts
  puts("n = #{n}")

  if n == 1
    # puts '=========='
    # puts(x, y)
    puts("return #{x} * #{y} = #{x * y}")
    return x * y
  end

  # middle = (n.to_f/2).floor
  middle = (n.to_f/2).ceil

  if n > x_string.length
    a = 0
    b = x
  else
    a = x_string[0...middle].to_i
    b = x_string[(middle)...x_string.length].to_i
  end

  if n > y_string.length
    c = 0
    d = y
  else
    c = y_string[0...middle].to_i
    d = y_string[(middle)...y_string.length].to_i  
  end

  puts '=========='
  puts "x = #{x}, y = #{y}"
  puts("n/2: #{n.to_f/2} => middle = #{middle}")
  puts("x length: #{x_string.length}, y length: #{y_string.length}")
  puts("a,b,c,d: #{a},#{b},#{c},#{d}")

  ac = product(a, c)
  bd = product(b, d)
  puts "a + b = #{a} + #{b} = #{a + b}"
  puts "c + d = #{c} + #{d} = #{c + d}"
  gauss_trick = product(a + b, c + d)

  puts '=========='
  puts("ac - #{ac}")
  puts("bd - #{bd}")
  puts("(a+b) * (c+d) = #{gauss_trick}")
  puts("(ad + bc) = #{gauss_trick} - #{ac} - #{bd} = #{gauss_trick - ac - bd}")
  gauss_trick = gauss_trick - ac - bd
  puts("a+b = #{a+b}, c+d = #{c+d}")

  pow = n / 2
  pow = pow * 2

  puts '========== ac * 10 ^ n ===== (ad + bc) * 10 ^ (n/2) ===== bd'
  puts ac * (10 ** pow)
  puts gauss_trick * (10 ** (pow / 2)) 
  puts bd
  puts

  # return ac * (10 ** n) + gauss_trick * (10 ** (n / 2)) + bd

  return ac * (10 ** pow) + gauss_trick * (10 ** (pow / 2)) + bd

end

puts product(x,y)

