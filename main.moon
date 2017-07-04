export projection = require "lib/projection"
export fov        = 3000

require "lib"

love.keypressed = (key, isrepeat) =>
  state\press key
