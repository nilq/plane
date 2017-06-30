export plane = state\new!
export env   = require "src/env"
export ui    = require "src/ui"

plane.load = =>
  with plane
    .w = 1700
    .h = 1700
    .d = 1000

    .x = -.w / 2
    .y = 500
    .z = .w

    .env    = (env.make!\genfood 40, 40)\genheat 5, 5
    .status = ui.status.make 20, 20
  
plane.update = (dt) =>
  s = 400 * ((plane.z + 1000) / 1000)
  with love.keyboard
    if .isDown "space"
      plane.z += dt * s
    if .isDown "lshift"
      plane.z -= dt * s
    
    if .isDown "a"
      plane.x += dt * s
    if .isDown "d"
      plane.x -= dt * s

    if .isDown "w"
      plane.y += dt * s
    if .isDown "s"
      plane.y -= dt * s

plane.draw = =>
  love.graphics.push!
  love.graphics.translate love.graphics.getWidth! / 2, love.graphics.getHeight! / 2

  with love.graphics
    .setColor 200, 200, 200
    .rectangle "line", plane.x, plane.y, plane.w, plane.h

    foodlen = #plane.env.food

    for x = 0, #plane.env.food - 1
      for y = 0, #plane.env.food[1] - 1
        .setColor 100, 255, 100, plane.env.food[x][y] * 200
        .rectangle "fill", plane.x + x * (plane.w / foodlen), plane.y + y * (plane.h / foodlen), plane.w / foodlen, plane.h / foodlen

    heatlen = #plane.env.heat

    for x = 0, #plane.env.heat - 1
      for y = 0, #plane.env.heat[1] - 1
        .setColor plane.env.heat[x][y] * 255, 200, 255 - plane.env.heat[x][y] * 255, 100
        .rectangle "fill", plane.x + x * (plane.w / heatlen), plane.y + y * (plane.h / heatlen), plane.w / heatlen, plane.h / heatlen

        .setColor 200, 200, 200
        .rectangle "line", plane.x + x * (plane.w / heatlen), plane.y + y * (plane.h / heatlen), plane.w / heatlen, plane.h / heatlen

    .pop!

    --plane.status\draw!

plane