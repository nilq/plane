export plane = state\new!

r = 100

test_ball = ->
  ball = {
    x: math.random 200, 1000
    y: 500
    z: math.random -400, 400

    a: 0
    s: 10
  }

  if ball.s == 0
    ball = test_ball!

  ball

plane.load = =>
  with plane
    .balls = {}

    for i = 1, 100
      .balls[#.balls + 1] = test_ball! 
  
plane.update = (dt) =>
  for ball in *plane.balls
    ball.a += ball.s * dt
  
plane.draw = =>
  with _projection.graphics
    for ball in *plane.balls
      love.graphics.setColor (math.random 0, 255), (math.random 0, 255), math.random 0, 255
      
      .circle _fov, "fill", {ball.x + r * (math.cos ball.a), ball.y, ball.z + r * math.sin ball.a}, 10

plane