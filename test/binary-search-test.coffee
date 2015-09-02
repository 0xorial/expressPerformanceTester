assert = require('chai').assert
search = require '../src/binary-search'
Promise = require 'bluebird'

epsilonEquals = (a, b, epsilon) ->
  return Math.abs(a - b) < epsilon

describe 'binary-search', ->
  it 'finds number in closed range', ->
    r = search({
      min: 0
      max: 10
      criterion: (testValue) -> testValue > 6.5
      epsilon: 0.2
      maxIterations: 10
      })
    assert.isTrue(epsilonEquals(r, 6.5, 0.2), r.toString())

  it 'finds number in right open range', ->
    r = search.right({
      min: 0
      criterion: (testValue) -> testValue > 6.5
      epsilon: 0.2
      maxIterations: 10
      })
    assert.isTrue(epsilonEquals(r, 6.5, 0.2), r.toString())

  it 'finds number in closed range async', (done) ->
    search.async({
      min: 0
      max: 10
      criterion: (testValue) ->
        return new Promise (resolve, reject) ->
          resolve(testValue > 6.5)
      epsilon: 0.2
      maxIterations: 10
      })
    .then (r) ->
      assert.isTrue(epsilonEquals(r, 6.5, 0.2), r.toString())
    .finally ->
      done()

  it 'finds number in right open range async', (done) ->
    search.rightAsync({
      min: 0
      criterion: (testValue) ->
        return new Promise (resolve, reject) ->
          resolve(testValue > 6.5)
      epsilon: 0.2
      maxIterations: 10
      })
    .then (r) ->
      assert.isTrue(epsilonEquals(r, 6.5, 0.2), r.toString())
    .finally ->
      done()

  it 'while promise', (done) ->
    i = 0
    search.promiseWhile (-> return Promise.resolve(i < 100)),
    ->
      return new Promise (resolve, reject) ->
        i++
        resolve()

    .then ->
      done()


