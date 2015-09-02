Promise = require 'bluebird'

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


promiseWhile = module.exports.promiseWhile = (condition, body) ->
  return new Promise (resolve, reject) ->
    loop1 = ->
      condition()
      .then (value) ->
        if value
          return body()
            .then ->
              return loop1()
        else
          resolve()

    loop1()



module.exports.async = (options) ->
  lower = options.min
  upper = options.max
  middle = 0
  options.maxIterations ?= 1000000000
  i = 0

  loop1 = promiseWhile ( -> Promise.resolve((upper - lower) > options.epsilon)),
    ->
      middle = lower + (upper - lower) / 2
      return options.criterion(middle)
      .then (value) ->
        if value
          upper = middle
        else
          lower = middle

        if i++ > options.maxIterations
          throw new Error('too many iterations. result: ' + middle)

        return

  return loop1.then -> middle



module.exports.rightAsync = (options) ->
  options.stepMultiplier ?= 2
  options.initialStep ?= options.epsilon
  step = options.initialStep
  upper = options.min
  i = 0
  shoudldStop = false

  promiseWhile ( -> Promise.resolve(!shoudldStop)),
    ->
      upper += step
      return options.criterion(upper)
      .then (value) ->
        if value
          shoudldStop = true
        else
          step *= options.stepMultiplier
          if i++ > options.maxIterations
            throw new Error('too many iterations. result: ' + upper)

  .then ->

    return module.exports.async({
      min: options.min
      max: upper
      maxIterations: options.maxIterations - i
      criterion: options.criterion
      epsilon: options.epsilon
      })