export plane = state\new!
export env   = require "src/env"
export ui    = require "src/ui"

plane.load = =>
  with plane
    .w = 1700
    .h = 1700
    .d = 1000

    .count = 0
    .epoch = 0

    .x = -.w / 2
    .y = 500
    .z = .w

    .env    = ((env.make!\genfood 15, 15)\genheat 1, 1)\genagents 300, .w, .h, .z
    .status = ui.status.make 20, 20
  
plane.update = (dt) =>
  plane.count += 1

  if @count >= 10000
    plane.count  = 0
    plane.epoch += 1
  
  if @count % 60 == 0
    fx = util.randi 0, #plane.env.food
    fy = util.randi 0, #plane.env.food[1]

    plane.env.food[fx][fy] = 0.5 -- todo; store this value

  -- starvation
  for i = 0, #plane.env.agents
    agent = plane.env.agents[i]

    loss = 0.0002 + 0.0001 * ((math.abs agent.w1) + (math.abs agent.w2)) / 2
    loss = 0.001 if agent.w1 < 0.1 and agent.w2 < 0.1

    if agent.boosting
      agent.health -= loss * 4
    else
      agent.health -= loss

  -- remove deads
  for i = 1, #plane.env.agents
    continue if not plane.env.agents[i]
    table.remove plane.env.agents, i if plane.env.agents[i].health <= 0

  s = math.abs 400 * ((plane.z + 1000) / 1000)
  with love.keyboard
    if .isDown "space"
      plane.z += dt * 400
    if .isDown "lshift"
      plane.z -= dt * 400
    
    if .isDown "a"
      plane.x += dt * s
    if .isDown "d"
      plane.x -= dt * s

    if .isDown "w"
      plane.y += dt * s
    if .isDown "s"
      plane.y -= dt * s

  for i = 0, #plane.env.agents
    plane.env.agents[i]\update plane

plane.draw = =>
  love.graphics.push!
  love.graphics.translate love.graphics.getWidth! / 2, love.graphics.getHeight! / 2

  with projection.graphics
    love.graphics.setColor 200, 200, 200
    .square3d fov, "line", {plane.x, plane.y, plane.z}, plane.w, plane.h
    .square3v fov, "line", {plane.x, plane.y, plane.z - plane.d}, plane.w, plane.h
    .square3v fov, "line", {plane.x + plane.w, plane.y, plane.z - plane.d}, plane.w, plane.h
    .square3h fov, "line", {plane.x , plane.y, plane.z - plane.d}, plane.w, plane.h
    .square3h fov, "line", {plane.x , plane.y + plane.h, plane.z - plane.d}, plane.w, plane.h

  with projection.graphics
    -- organisms
    for i = 0, #plane.env.agents
      agent     = plane.env.agents[i]
      pos = {plane.x + agent.pos[1], plane.y + agent.pos[2], plane.z - 10}

      love.graphics.setColor agent.color[1], agent.color[2], agent.color[3] 
      .circle fov, "fill", pos, 10

      love.graphics.setColor 150, 150, 150
      .circle fov, "line", pos, 10

      love.graphics.setColor 0, 0, 0
      .line fov, pos, {pos[1] + (15 * math.cos agent.angle), pos[2] + (15 * math.sin agent.angle), pos[3] - 5}

      love.graphics.setColor agent.color[1], agent.color[2], agent.color[3] 
      .circle fov, "fill", {pos[1], pos[2], pos[3] - 10}, 10

      love.graphics.setColor 150, 150, 150
      .circle fov, "line", {pos[1], pos[2], pos[3] - 10}, 10
      

      --love.graphics.setColor 150, 150, 150
      --.line fov, pos, {pos[1], pos[2], plane.z - 100}

      --love.graphics.setColor 150, 150, 150
      --.square3d fov, "fill", {pos[1], pos[2], plane.z - 50}, 5, 25

      --love.graphics.setColor 150, 255, 150
      --.square3d fov, "fill", {pos[1], pos[2], plane.z - 50}, 5, agent.health * 25

    -- heat fields
    heatlen = #plane.env.heat

    for x = 0, #plane.env.heat - 1
      for y = 0, #plane.env.heat[1] - 1
        love.graphics.setColor plane.env.heat[x][y] * 255, 200, 255 - plane.env.heat[x][y] * 255, 20
        .square3d fov, "cross?", {plane.x + x * (plane.w / heatlen), plane.y + y * (plane.h / heatlen), plane.z - 1}, plane.w / heatlen, plane.h / heatlen

        love.graphics.setColor 200, 200, 200
        .square3d fov, "line", {plane.x + x * (plane.w / heatlen), plane.y + y * (plane.h / heatlen), plane.z}, plane.w / heatlen, plane.h / heatlen

    -- food fields
    foodlen = #plane.env.food
    foodw   = plane.w / foodlen
    foodh   = plane.h / foodlen

    for x = 0, #plane.env.food - 1
      for y = 0, #plane.env.food[1] - 1
        love.graphics.setColor 100, 255, 100, plane.env.food[x][y] * 190
        .cube fov, "fill", {plane.x + x * (plane.w / foodlen), plane.y + (y + 1) * (plane.h / foodlen), plane.z - 1}, foodw, foodh, 1

        if plane.env.food[x][y] > 0.001

          top = {plane.x + x * (plane.w / foodlen) + foodw / 2, plane.y + y * (plane.h / foodlen) + foodh / 2, plane.z - 100}
          
          love.graphics.setColor 150, 150, 150
          .line fov, {plane.x + x * (plane.w / foodlen) + foodw / 2, plane.y + y * (plane.h / foodlen) + foodh / 2, plane.z}, top

          love.graphics.setColor 255, 150, 150
          .print fov, (string.format "%.1f", plane.env.food[x][y] * 100) .. "%", top

    love.graphics.pop!

    plane.status\draw!

plane