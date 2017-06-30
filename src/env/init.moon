agent = require "src/agent"

make = ->
  env = {
    food:   {}
    heat:   {}
    agents: {}
  }

  env.genfood = (cellw, cellh) =>
    with env
      for x = 0, cellw
        a = {}
        for y = 0, cellh
          if 0 == math.random 0, 10
            a[y] = math.random 0, 0.5
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

  env.genagents = (n, w, h, z) =>
    for x = 0, n
      @agents[x] = agent.random w, h, z
    env

  env

{
  :make
}