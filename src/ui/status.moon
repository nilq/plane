make = (x, y) ->
  status      = {:x, :y}
  status.draw = =>
    with love.graphics
      .push!
      .scale 2, 2

      .setColor 200, 200, 200, 200
      .rectangle "fill", @x, @y, 120, 190

      .setColor 150, 150, 150
      .print "#{love.timer.getFPS!} FPS",  @x + 15, @y + 15

      .setColor 100, 200, 100
      .print "#{#plane.env.agents} agents",  @x + 15, @y + 40

      temp = 0
      for x = 0, #plane.env.heat
        for y = 0, #plane.env.heat[1]
          temp += plane.env.heat[x][y]

      .setColor 200, 100, 100

      .print "#{string.format "%.2f", temp * 15} celcius",  @x + 15, @y + 65
      --.print "#{#plane.env.agents} agents",  @x + 15, @y + 90

      .pop!

  status

{
  :make
}
