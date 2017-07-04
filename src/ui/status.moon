make = (x, y) ->
  status      = {:x, :y}
  status.draw = =>
    with love.graphics
      .push!
      .scale 2, 2

      .setColor 200, 200, 200, 200
      .rectangle "fill", @x, @y, 120, 190

      .setColor 150, 150, 150
      .print "censored FPS",  @x + 15, @y + 15

      .setColor 100, 200, 100
      .print "#{#plane.env.agents} agents",  @x + 15, @y + 40


      food = 0
      for x = 0, #plane.env.food
        for y = 0, #plane.env.food[1]
          food += 1 if plane.env.food[x][y] > 0.01

      .setColor 100, 200, 100
      .print "#{food} food",  @x + 15, @y + 65

      temp = 0
      acc  = 0
      for x = 0, #plane.env.heat
        for y = 0, #plane.env.heat[1]
          temp += plane.env.heat[x][y]
          acc  += 1

      .setColor 200, 100, 100

      .print "#{string.format "%.2f", (temp * 15) / acc} celcius",  @x + 15, @y + 90

      .setColor 100, 100, 255
      .print "#{plane.epoch} epochs",  @x + 15, @y + 115

      .pop!

  status

{
  :make
}
