# 发布车源
request = require './common'
should = require 'should'
config = require './config'

describe '发布车源', ->
	it '发布车源', (done)->
		request.post config.api.release_car, {
			fromProvince: '1'
			fromCity: '1'
			fromArea: '1'
			fromStreet: '1'
			toProvince: '1'
			toCity: '2'
			toArea: '2'
			toStreet: '2'
			startTime: ''
			endTime: ''
			isinvoice: '0'
			contacts: '盘代军'
			phone: '18669001623'
			remark: '11'
			carId: '7714d0d83c7f47f4bcfac62b9a1bf101'
		}, (result) ->
			should.exists result
			# result[0].rl.should.not.be.empty()
			# result[0].rl[0].rl.should.not.be.empty()
			done()
