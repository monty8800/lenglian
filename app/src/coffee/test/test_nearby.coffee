request = require './common'
should = require 'should'
config = require './config'

describe '测试附近', ->
	rightLng = '124.075610'
	rightLat = '48.758752'

	leftLng = '108.404454'
	leftLat = '28.953292'

	apiList = [config.api.NEARBY_CAR, config.api.NEARBY_WAREHOUSE, config.api.NEARBY_GOODS]

	for api in apiList

		it '附近找车', (done)->
			request.post api, {
				leftLng: leftLng
				leftLat: leftLng
				rightLng: rightLng
				rightLat: rightLat
			}, (data)->
				done()
