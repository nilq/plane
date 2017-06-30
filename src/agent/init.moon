brain = require "src/agent/brain"

radius      = 10
speed       = 0.5
boost_speed = 2

random = (w, h, z) ->
  agent = {
    pos: {
      [1]: math.random 0, w
      [2]: math.random 0, h
      [3]: 0 -- gross
    }

    color: {
      [1]: math.random 0, 255
      [2]: math.random 0, 255
      [3]: math.random 0, 255
    }
  }

  with agent
    .brain = brain.dwraonn.make!

    .w1       = 0 -- wheel1
    .w2       = 0 -- wheel2
    .boosting = false

    .angle = util.randf -math.pi, math.pi

    .out = {}
    for i = 0, brain.settings.outputs
      .out[i] = 0
    
    .inp = {}
    for i = 0, brain.settings.inputs
      .inp[i] = 0

    .tick = =>
      @brain\tick @inp, @out
    
    .update = =>
      @tick!
      @get_brain!

      -- movement
      whp1 = { -- wheel position
        radius * (math.cos @angle - math.pi / 4) + @pos[1]
        radius * (math.sin @angle - math.pi / 4) + @pos[2]
      }

      whp2 = { -- wheel position
        radius * (math.cos @angle + math.pi / 4) + @pos[1]
        radius * (math.sin @angle + math.pi / 4) + @pos[2]
      }

      boost1 = speed * @w1
      boost2 = speed * @w2

      if @boosting
        boost1 *= boost_speed
        boost2 *= boost_speed
      
      vv1 = {
        boost1 * (math.cos math.atan2 whp1[2] - @pos[2], whp1[1] - @pos[1])
        boost1 * (math.sin math.atan2 whp1[2] - @pos[2], whp1[1] - @pos[1])
      }

      vv2 = {
        boost2 * (math.cos math.atan2 whp2[2] - @pos[2], whp2[1] - @pos[1])
        boost2 * (math.sin math.atan2 whp2[2] - @pos[2], whp2[1] - @pos[1])
      }

      @angle = math.atan2 vv1[2] + vv2[2], vv1[1] + vv2[1]

      @pos[1] += vv1[1]
      @pos[2] += vv1[2]

      @pos[1] += vv2[1]
      @pos[2] += vv2[2]

      @pos[1] %= w
      @pos[2] %= h
    
    .get_brain = =>
      @w1 = @out[1]
      @w2 = @out[2]
  
  agent

{
  :random
}