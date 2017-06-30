export state = require "lib/state"
export util  = require "lib/util"

export shine = require "lib/shine"

with love
  .graphics.setDefaultFilter "nearest", "nearest"
  .graphics.setBackgroundColor 255, 255, 255

  post_effect = shine.scanlines!\chain (shine.crt!\set "x", 0.04)\set "y", 0.045

  .run = ->
    dt = 0

    update_time  = 0
    target_delta = 1 / 60

    .math.setRandomSeed os.time! if .math
    .load !                      if .load
    .timer.step!                 if .timer

    state\set "src/core"
    state\load!

    while true
      update_time += dt

      if love.event
        .event.pump!

        for name, a, b, c, d, e, f in .event.poll!
          if "quit" == name
            return a unless .quit or not .event.quit!
          
          .handlers[name] a, b, c, d, e, f
      
      if .timer
        .timer.step!
        dt = .timer.getDelta!
      
      if update_time > target_delta
        state\update dt
      
      if .graphics and .graphics.isActive!
        .graphics.clear .graphics.getBackgroundColor!
        .graphics.setColor 255, 255, 255

        .graphics.origin!

        post_effect\draw ->
          state\draw!

        .graphics.present!

      .timer.sleep 0.001 if .timer