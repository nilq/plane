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
  self.state.unload! if self.state.unload

  matches = {}

  for match in string.gmatch path, "[^;]+"
    matches[#matches + 1] = match

  path = matches[1]

  package.loaded[path] = false

  self.state = require path

  self.state.load args if self.state.load
  self


state.load = =>
  self.state\load!
  self

state.update = (dt) =>
  self.state\update dt if self.state.update
  self

state.draw = =>
  self.state.draw! if self.state.update
  self

state.press = (key, isrepeat) =>
  self.state.press key, isrepeat if self.state.press
  self

state