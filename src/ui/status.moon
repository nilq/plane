make = (x, y) ->
  status      = {:x, :y}
  status.draw = =>
    with love.graphics
      .push!
      .scale 2, 2

      .setColor 200, 200, 200, 200
      .rectangle "fill", @x - 7, @y, 120, 190

      .setColor 150, 150, 150
      .print "\n status test yes\n\n population: 0\n\n temp: 20\n\n air: enough\n\n ketchup: no\n\n time: 1x", @x, @y

      .pop!

  status

{
  :make
}