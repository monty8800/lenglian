request = require './common'
should = require 'should'
config = require './config'

describe '我要找车', ->
	it '我要找车', (done)->
		params = {
			startNo: 1
			pageSize: 10
			fromProvinceId: ''
			fromCityId: ''
			fromAreaId: ''
			toProvinceId: ''
			toCityId: ''
			toAreaId: ''
			vehicle: ''
			heavy: ''
			isInvoice: ''
			carType: ''
			id: ''
		}
		request.post config.api.found_car, params, (result)->
			done()