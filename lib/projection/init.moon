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

{
  :project
  :projectn

  graphics: {
    :line
    :circle
    :triangle
  }
}