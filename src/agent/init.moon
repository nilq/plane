random = (w, h, z) ->
  agent = {
    pos: {
      [1]: math.random 0, w
      [2]: math.random 0, h
      [3]: z
    }
  }

  agent.draw = =>
    love.graphics.setColor 255, 0, 0
    with _projection.graphics
      .circle _fov, "fill", @pos, 10
  
  agent

{
  :random
}