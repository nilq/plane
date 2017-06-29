export _projection = require "lib/projection"
export _fov        = 3000

require "lib"

love.keypressed = (key, isrepeat) =>
  state\press key