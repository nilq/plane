brain = require "src/agent/brain"

radius      = 10
speed       = 0.5
boost_speed = 2

rep = 2

rep_rate = (herb, c=rep, h=rep) ->
  herb * (util.randf c - 0.1, h + 0.1) + (1 - herb) * util.randf c - 0.1, h + 0.1

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
    :radius
  }

  with agent
    .brain = brain.dwraonn.make!

    .w1       = 0 -- wheel1
    .w2       = 0 -- wheel2
    .boosting = false
    .health   = 1 + util.randf 0, 0.1
    .herb     = util.randf 0, 1

    .sound_mul = 0
    .gen_count = 0

    .fur = util.randf -1, 1

    .rep_count = rep_rate .herb

    .clock_f1 = util.randf 5, 100
    .clock_f2 = util.randf 5, 100

    .mut_rate1 = 0.003
    .mut_rate2 = 0.05

    .spike_len = 0

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

      if plane.count % 2 == 0
        for i = 1, #plane.env.agents
          other = plane.env.agents[i]
          continue if other == @

          d = util.distance @pos, other.pos

          if d < 2 * @radius
            diff = math.atan2 other.pos[2] - @pos[2], other.pos[1] - @pos[1]

            if math.pi / 8 > math.abs diff
              mult = 1
              mult = 2 if @boosting

              dmg = 0.5 * @spike_len * 2 * math.max (math.abs @w1), math.abs @w2

              other.health -= dmg

              @spike_len = 0

      -- rep
      if @rep_count < 0 and @health > 0.65
        plane.env\spawn @make_baby @mut_rate1, @mut_rate2
        @rep_count = rep_rate .herb

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
        itk       = math.min food, 0.0325 -- intake constant
        speed_mul = (1 - (math.abs @w1 + math.abs @w2) / 2) / 2 + 0.5

        itk *= @herb^2 * speed_mul

        @health    += itk
        @rep_count -= 3 * itk

        plane.env.food[cx][cy] -= math.min food, 0.003 -- food waste constant

    .input = (plane) =>
      pi8  = math.pi / 8 / 2
      pi38 = pi8 * 3

      -- health
      @inp[11] = util.cap @health / 2

      -- food
      cx = math.floor @pos[1] / (plane.w / #plane.env.food)
      cy = math.floor @pos[2] / (plane.h / #plane.env.food)

      @inp[9] = plane.env.food[cx][cy] / 0.5 -- food maxima is 0.5

      -- sound, smell and eyes
      p1, r1, g1, b1 = 0, 0, 0, 0
      p2, r2, g2, b2 = 0, 0, 0, 0
      p3, r3, g3, b3 = 0, 0, 0, 0

      sound_acc = 0
      smell_acc = 0
      hear_acc  = 0

      blood = 0

      for i = 0, #plane.env.agents
        agent = plane.env.agents[i]
        continue if agent == @

        x1 = @pos[1] < agent.pos[1] - 150
        x2 = @pos[1] > agent.pos[1] + 150

        y1 = @pos[2] > agent.pos[2] + 150
        y2 = @pos[2] < agent.pos[2] - 150

        continue if x1 or x2 or y1 or y2

        d = util.distance @pos, agent.pos

        if d < 150
          smell_acc += 0.3 * (150 - d) / 150
          sound_acc += 0.4 * (150 - d) / 150
          hear_acc  += agent.sound_mul * (150 - d) / 150

          angle = math.atan2 (@pos[2] - agent.pos[2]), (@pos[1] - agent.pos[1])

          -- completely unreadable madness
          l_eye_ang = @angle - pi8
          r_eye_ang = @angle + pi8

          back_angle = @angle + math.pi
          forw_angle = @angle

          l_eye_ang  += 2 * math.pi if l_eye_ang  < -math.pi
          r_eye_ang  -= 2 * math.pi if r_eye_ang  >  math.pi
          back_angle -= 2 * math.pi if back_angle >  math.pi

          diff1 = l_eye_ang - angle
          diff1 = 2 * math.pi - math.abs diff1 if math.pi < math.abs diff1
          diff1 = math.abs diff1

          diff2 = r_eye_ang - angle
          diff2 = 2 * math.pi - math.abs diff2 if math.pi < math.abs diff2
          diff2 = math.abs diff2

          diff3 = back_angle - angle
          diff3 = 2 * math.pi - math.abs diff3 if math.pi < math.abs diff3
          diff3 = math.abs diff3

          diff4 = forw_angle - angle
          diff4 = 2 * math.pi - math.abs forw_angle if math.pi < math.abs forw_angle
          diff4 = math.abs diff4

          if diff1 < pi38
              mul1 = 2 *((pi38 - diff1) / pi38) * ((150 - d) / 150)

              p1 += mul1 * (d / 150)

              r1 += mul1 * agent.color[1]
              g1 += mul1 * agent.color[2]
              b1 += mul1 * agent.color[3]

          if diff2 < pi38
              mul2 = 2 *((pi38 - diff1) / pi38) * ((150 - d) / 150)

              p2 += mul2 * (d / 150)

              r2 += mul2 * agent.color[1]
              g2 += mul2 * agent.color[2]
              b2 += mul2 * agent.color[3]

          if diff3 < pi38
              mul3 = 2 *((pi38 - diff1) / pi38) * ((150 - d) / 150)

              p3 += mul3 * (d / 150)

              r3 += mul3 * agent.color[1]
              g3 += mul3 * agent.color[2]
              b3 += mul3 * agent.color[3]

          if diff4 < pi38
              mul4 = 2 *((pi38 - diff1) / pi38) * ((150 - d) / 150) -- 2 == blood_sens

              blood += mul4 * (1 - agent.health / 2)

          @inp[1] = util.cap p1
          @inp[2] = util.cap r1
          @inp[3] = util.cap g1
          @inp[4] = util.cap b1
          @inp[5] = util.cap p2
          @inp[6] = util.cap r2
          @inp[7] = util.cap g2
          @inp[8] = util.cap b2

          @inp[10] = util.cap sound_acc
          @inp[12] = util.cap smell_acc

          @inp[13] = util.cap p3
          @inp[14] = util.cap r3
          @inp[15] = util.cap g3
          @inp[16] = util.cap b3

          @inp[17] = math.abs math.sin plane.count / @clock_f1
          @inp[18] = math.abs math.sin plane.count / @clock_f2

          @inp[19] = util.cap hear_acc
          @inp[20] = util.cap blood

    .output = =>
      @w1 = @out[1]
      @w2 = @out[2]

      @color[1] = @out[3] * 255
      @color[2] = @out[4] * 255
      @color[2] = @out[5] * 255

      g = @out[6]
      if @spike_len < g
        @spike_len += 0.05
      else
        @spike_len = g

      @boosting = @out[7] > .5

      @sound_mul = @out[8]

    .make_baby = (mr, mr2) =>
      baby = random w, h, z

      -- behind
      baby.pos = {
        @pos[1] + radius + util.randf -radius * 2, radius * 2
        @pos[2] + util.randf -radius * 2, radius * 2
        @pos[3]
      }

      baby.pos[1] %= w
      baby.pos[2] %= h

      baby.gen_count = @gen_count + 1
      baby.rep_count = rep_rate baby.herb

      baby.mut_rate1 = @mut_rate1
      baby.mut_rate2 = @mut_rate2

      if .2 > util.randf 0, 1
        baby.mut_rate1 = util.randn @mut_rate1, 0.002

      if .2 > util.randf 0, 1
        baby.mut_rate2 = util.randn @mut_rate2, 0.05

      @mut_rate1 = 0.001 if @mut_rate1 < 0.001
      @mut_rate1 = 0.025 if @mut_rate1 < 0.025

      baby.herb = util.cap @herb, mr2 * 4

      baby.fur = @fur

      if mr * 5 > util.randf 0, 1
        baby.fur = util.randf baby.fur, mr2

      baby.clock_f1 = @clock_f1
      baby.clock_f2 = @clock_f2

      if mr * 5 > util.randf 0, 1
        baby.clock_f1 = util.randf baby.clock_f1, mr2

      if mr * 5 > util.randf 0, 1
        baby.clock_f2 = util.randf baby.clock_f2, mr2

      baby.clock_f1 = 2 if baby.clock_f1 < 2
      baby.clock_f2 = 2 if baby.clock_f2 < 2

      baby.brain = brain.dwraonn.from @brain
      baby.brain\mutate mr, mr2

      baby

  agent

{
  :random
}
