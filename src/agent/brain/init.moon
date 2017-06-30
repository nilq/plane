--- bad oop approach on neural net
-- brain settings
brain_size  = 150
connections = 4
inputs      = 20
outputs     = 9

-- neuron representation
neuron      = {}
neuron.make = ->
  box = {}

  with box
    .type = 0
    .type = 1 if 0 == util.randi 0, 1

    -- damping strength
    .kp = util.randf 0.8, 1

    .w      = {} -- weights
    .id     = {} -- connection indexes
    .notted = {} -- notted connection

    for i = 0, connections
      .w[i]  = util.randf 0.1, 2

      .id[i] = util.randi 0, brain_size
      .id[i] = util.randi 1, inputs if 0.2 > util.randi 1, inputs

      .notted[i] = 0 == util.randi 0, 1
    
    .bias   = util.randf -1, 1
    .target = 0
    .out    = 0

  box

-- damp weighted recurrent and/or neural network
dwraonn      = {}
dwraonn.make = ->
  brain = {}

  with brain
    .neurons = {}

    for i = 0, brain_size
      a = neuron.make!

      .neurons[i] = a
      
      for j = 0, connections
        a.id[j] = 1  if 0.05 > util.randf 0, 1
        a.id[j] = 5  if 0.05 > util.randf 0, 1
        a.id[j] = 12 if 0.05 > util.randf 0, 1
        a.id[j] = 4  if 0.05 > util.randf 0, 1
        
        a.id[j] = util.randi 1, inputs if i < brain_size / 2
  
    .tick = (input, output) =>
      for i = 0, inputs
        .neurons[i].out = input[i]
      
      for i = inputs, brain_size
        a = .neurons[i]

        if a.type == 0
          res = 1

          for j = 0, connections
            idx = a.id[j]
            val = .neurons[idx].out

            if a.notted[j]
              val = 1 - val

            res *= val
            
          res     *= a.bias
          a.target = res
        else
          res = 0

          for j = 0, connections
            idx = a.id[j]
            val = .neurons[idx].out

            if a.notted[j]
              val = 1 - val
            
            res += val * a.w[j]
          
          res     += a.bias
          a.target = res
        
        if a.target < 0
          a.target = 0
        else
          if a.target > 1
            a.target = 1
      
      for i = inputs, brain_size
        a      = .neurons[i]
        a.out += (a.target - a.out) * a.kp
      
      for i = 1, outputs
        output[i] = .neurons[brain_size - i].out

  brain

{
  :neuron
  :dwraonn

  settings: {
    :brain_size
    :connections
    :inputs
    :outputs
  }
}