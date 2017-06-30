make = ->
  env = {
    food: {}
    heat: {}
  }

  env.genfood = (cellw, cellh) =>
    with env
      for x = 0, cellw
        a = {}
        for y = 0, cellh
          if 0 == math.random 0, 10
            a[y] = math.random 0, 255
          else
            a[y] = 0

        @food[x] = a
    env
  
  env.genheat = (cellw, cellh) =>
    for x = 0, cellw
      a = {}
      for y = 0, cellh
        a[y] = util.randf 0, 1

      @heat[x] = a
    env

  env

{
  :make
}