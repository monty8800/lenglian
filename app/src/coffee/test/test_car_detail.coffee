request = require './common'
should = require 'should'
config = require './config'

describe '车辆详情', ->
	it '车辆详情', (done)->
		request.post config.api.car_detail, {
				carId: '9f5d91332ea14017a6c406f9649fb1e1'
			}, (result) ->
				should.exists result
				done()     