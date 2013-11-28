# fibonnaci example
def fib n
  return n if n < 2

  a = 0
  b = 1
  c = 0
  i = 0

  while(i < n)
    c = a + b
    a = b
    b = c
    i += 1
  end

  c
end
