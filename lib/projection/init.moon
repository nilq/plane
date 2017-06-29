-- project decrements amount of dimensions
-- number -> table -> table, number
project = (fov, point) ->
  scale  = fov / (fov + point[#point])
  point2 = {}

  for coord in *point
    point2[#point2 + 1] = coord * scale

    if #point2 - (#point - 1) == 0
      return point2, scale

-- projectn recursively decrements amount of dimensions
-- ... towards given amount
-- number -> number -> table -> table, scale
projectn = (dimension, fov, point) ->
  point2, scale = project fov, point

  if dimension - #point2 == 0
    return point2, scale
  else
    projectn dimension, fov, point2

-- line draws a 2d line between two given arbitrary dimensional points
-- number -> table -> table -> nil
line = (fov, p1, p2) ->
  pn1, s1 = projectn 2, fov, p1
  pn2, s2 = projectn 2, fov, p2

  with love.graphics
    .line pn1[1] * s1, pn1[2] * s1, pn2[1] * s2, pn2[2] * s2

-- circle draws a 2d circle on a given arbitrary dimensional point
-- number -> string -> table -> number -> table -> nil
circle = (fov, mode, p1, radius, segments) ->
  pn1, s1 = projectn 2, fov, p1

  with love.graphics
    .circle mode, pn1[1] * s1, pn1[2] * s1, radius * s1, segments

-- triangle draws a 2d triangle between given arbitray dimensional points
-- number -> string -> table -> table -> table -> nil
triangle = (fov, mode, p1, p2, p3) ->
  pn1, s1 = projectn 2, fov, p1
  pn2, s2 = projectn 2, fov, p2
  pn3, s3 = projectn 2, fov, p3

  with love.graphics
    .polygon mode, pn1[1] * s1, pn1[2] * s1, pn2[1] * s2, pn2[2] * s2, pn3[1] * s3, pn3[2] * s3

square3 = (fov, mode, p1, p2, p3, p4) ->
  switch mode
    when "fill"
      triangle fov, "fill", p1, p2, p3
      triangle fov, "fill", p2, p3, p4
      triangle fov, "fill", p3, p4, p1
    
    when "line"
      line fov, p1, p2
      line fov, p2, p3
      line fov, p3, p4
      line fov, p4, p1

-- horizontal
square3h = (fov, mode, p1, width, height) ->
  p2 = {p1[1] + width, p1[2], p1[3]}
  p3 = {p1[1] + width, p1[2], p1[3] + height}
  p4 = {p1[1], p1[2], p1[3] + height}

  square3 fov, mode, p1, p2, p3, p4

-- vertical
square3v = (fov, mode, p1, width, height) ->
  p2 = {p1[1], p1[2] + width, p1[3]}
  p3 = {p1[1], p1[2] + width, p1[3] + height}
  p4 = {p1[1], p1[2], p1[3] + height}

  square3 fov, mode, p1, p2, p3, p4

-- depth
square3d = (fov, mode, p1, width, height) ->
  p2 = {p1[1] + width, p1[2], p1[3]}
  p3 = {p1[1] + width, p1[2] + height, p1[3]}
  p4 = {p1[1], p1[2] + height, p1[3]}

  square3 fov, mode, p1, p2, p3, p4

cube = (fov, mode, p1, width, height, depth) ->
  square3h fov, mode, {p1[1],         p1[2],          p1[3]},         width, height
  square3h fov, mode, {p1[1],         p1[2] - height, p1[3]},         width, height
  square3v fov, mode, {p1[1],         p1[2] - height, p1[3]},         width, height
  square3v fov, mode, {p1[1] + width, p1[2] - height, p1[3]},         width, height
  square3d fov, mode, {p1[1],         p1[2] - height, p1[3] + depth}, width, height
  square3d fov, mode, {p1[1],         p1[2] - height, p1[3]},         width, height

{
  :project
  :projectn

  graphics: {
    :line
    :circle
    :triangle
    :square3
    :square3h
    :square3v
    :square3d
    :cube
  }
}