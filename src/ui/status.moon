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
      .print (string.format "%.4fdt", love.timer.getDelta!), @x + 15, @y + 40

      .pop!

  status

{
  :make
}