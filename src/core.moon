export plane = state\new!

plane.load = =>
  with plane
    .w = 1000
    .h = 1000
    .d = 1000

    .x = -.w / 2
    .y = 500
    .z = .w
  
plane.update = (dt) =>
  s = 400
  with love.keyboard
    if .isDown "w"
      plane.z += dt * s
    if .isDown "s"
      plane.z -= dt * s
    
    if .isDown "d"
      plane.x += dt * s
    if .isDown "a"
      plane.x -= dt * s

    if .isDown "lshift"
      plane.y += dt * s
    if .isDown "space"
      plane.y -= dt * s

plane.draw = =>
  love.graphics.push!
  love.graphics.translate love.graphics.getWidth! / 2, love.graphics.getHeight! / 2
 
  with _projection.graphics
    love.graphics.setColor 200, 200, 200
    .square3h _fov, "line", {plane.x, plane.y, plane.z}, plane.w, plane.h, plane.d

  love.graphics.pop!

plane