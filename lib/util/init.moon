return_v = false
value_v  = 0

deepcopy = (org) ->
  copy = {}
  if "table" == type org
    for k, v in next, org, nil
        copy[deepcopy k] = deepcopy org
    setmetatable copy, deepcopy getmetatable org
  else
    copy = org
  copy

gauss_random = ->
  if return_v
    return_v = false
    return value_v

  u = 2 * math.random! - 1
  v = 2 * math.random! - 1

  r = u^2 + v^2

  if r == 0 or r > 1
    return gauss_random!

  c = math.sqrt -2 * (math.log r) / r
  value_v = v * c

  u * c

randf = (a, b) ->
  (b - a) * math.random! + a

randi = (a, b) ->
  math.floor (b - a) * math.random! + a

randn = (mu, sigma) ->
  mu + gauss_random! * sigma

cap = (n) ->
  if n < 0
    return 0
  if n > 1
    return 1
  n

distance = (a, b) ->
  math.sqrt (a[1] - b[1])^2 + (a[2] - b[2])^2

{
  :deepcopy
  :gauss_random
  :randf
  :randi
  :randn
  :cap
  :distance
}
