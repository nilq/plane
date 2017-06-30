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
    .health   = 1 + util.randf 0, 0.1
    .herb     = util.randf 0, 1

    .angle = util.randf -math.pi, math.pi

    .out = {}
    for i = 0, brain.settings.outputs
      .out[i] = 0
    
    .inp = {}
    for i = 0, brain.settings.inputs
      .inp[i] = 0

    .tick = =>
      @brain\tick @inp, @out
    
    .update = (plane) =>
      @input plane
      @tick!
      @output!

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

      @eat plane

    .eat = (plane) =>
      cx = math.floor @pos[1] / (plane.w / #plane.env.food)
      cy = math.floor @pos[2] / (plane.h / #plane.env.food)

      food = plane.env.food[cx][cy]

      if food > 0 and @health < 2 -- 2 is maxima
        itk       = math.min food, 0.00325 -- intake constant
        speed_mul = (1 - (math.abs @w1 + math.abs @w2) / 2) / 2 + 0.5

        itk *= @herb^2 * speed_mul

        @health  += itk

        plane.env.food[cx][cy] -= math.min food, 0.003 -- food waste constant
    
    .input = (plane) =>
      -- health
      @inp[1] = util.cap @health / 2

      -- food
      cx = math.floor @pos[1] / (plane.w / #plane.env.food)
      cy = math.floor @pos[2] / (plane.h / #plane.env.food)

      @inp[2] = plane.env.food[cx][cy] / 0.5 -- food maxima is 0.5

    .output = =>
      @w1 = @out[1]
      @w2 = @out[2]
  
  agent

{
  :random
}