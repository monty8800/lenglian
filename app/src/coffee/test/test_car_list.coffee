request = require './common'
should = require 'should'
config = require './config'

describe '我的车辆', ->
	it '我的车辆', (done)->
		params = {
			userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
			pageNow: 1,
			pageSize: 10,
			status: ''  
		}
		request.post config.api.my_car_list, params, (result)->
			should.exists result
			# result.myCarInfo should.be.Array()
			result.myCarInfo[0].driver.should.not.be.empty()
			done();          