state = {
  current: {}
  global: {
    update: {}
    draw: {}
  }
}

setmetatable state, state

state.new = => {}

state.set = (path, args) =>
  @current.unload! if @current.unload

  matches = {}

  for match in string.gmatch path, "[^;]+"
    matches[#matches + 1] = match

  path = matches[1]

  package.loaded[path] = false

  @current = require path

  @current.load args if @current.load
  @


state.load = =>
  @current\load! if @current.load
  @

state.update = (dt) =>
  @current\update dt if @current.update
  @

state.draw = =>
  @current\draw! if @current.update
  @

state.press = (key, isrepeat) =>
  @current\press key, isrepeat if @current.press
  @

state
