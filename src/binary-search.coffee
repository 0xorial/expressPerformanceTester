module.exports = (options) ->
  lower = options.min
  upper = options.max
  middle = 0
  options.maxIterations ?= 1000000000
  i = 0
  while (upper - lower) > options.epsilon
    middle = lower + (upper - lower) / 2
    value = options.criterion(middle)
    if value
      upper = middle
    else
      lower = middle

    if i++ > options.maxIterations
      throw new Error('too many iterations. result: ' + middle)

  return middle

module.exports.right = (options) ->
  options.stepMultiplier ?= 2
  options.initialStep ?= options.epsilon
  step = options.initialStep
  upper = options.min
  i = 0
  while true
    upper += step
    value = options.criterion(upper)
    if value
      break
    step *= options.stepMultiplier
    if i++ > options.maxIterations
      throw new Error('too many iterations. result: ' + upper)

  return module.exports({
    min: options.min
    max: upper
    maxIterations: options.maxIterations - i
    criterion: options.criterion
    epsilon: options.epsilon
    })

