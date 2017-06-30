export plane = state\new!
export env   = require "src/env"

plane.load = =>
  with plane
    .w = 1700
    .h = 1700
    .d = 1000

    .x = -.w / 2
    .y = 500
    .z = .w

    .env = env.make 40, 40
  
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
 
  with _projection.graphics
    love.graphics.setColor 200, 200, 200
    .square3d _fov, "line", {plane.x, plane.y, plane.z}, plane.w, plane.h, plane.d

    foodlen = #plane.env.food

    for x = 0, #plane.env.food - 1
      for y = 1, #plane.env.food[1]
        continue if plane.env.food[x][y] == 0
        love.graphics.setColor 100, 255, 100, plane.env.food[x][y] * 200
        .cube _fov, "fill", {plane.x + x * (plane.w / foodlen), plane.y + y * (plane.h / foodlen), plane.z}, plane.w / foodlen, plane.h / foodlen, plane.h / foodlen + 10

  love.graphics.pop!

plane