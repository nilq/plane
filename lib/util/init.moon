return_v = false
value_v  = 0

deep_copy = (org) ->
  copy = {}
  if "table" == type org
    for k, v in next, org, nil
        copy[deep_copy k] = deep_copy org
    setmetatable copy, deep_copy getmetatable org
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

{
  :deep_copy
  :gauss_random
  :randf
  :randi
  :randn
}