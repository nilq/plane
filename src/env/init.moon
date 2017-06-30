make = (cellw, cellh) ->
  env = {
    food: {}
  }

  with env
    for x = 0, cellw
      a = {}
      for y = 0, cellh
        if 0 >= math.random -2, 1
          a[y] = 0
        else
          a[y] = 1

      .food[x] = a
  env

{
  :make
}