request = require './common'
should = require 'should'
config = require './config'

describe '车辆详情', ->
	it '车辆详情', (done)->
		request.post config.api.car_detail, {
				carId: 'c33e64812d244b5a8ad7836ea8471578'
			}, (result) ->
				should.exists result
				done()  