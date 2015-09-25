request = require './common'
should = require 'should'
config = require './config'

describe '车主订单详情', ->
	it '车主订单详情', (done)->
		params = {
			carPersonUserId: '7714d0d83c7f47f4bcfac62b9a1bf101',
			orderNo: 'GC20150915100000204' # 订单号
		}
		request.post config.api.carowner_order_detail, params, (result)->
			should.exists result
			# result.myCarInfo should.be.Array()
			# result.myCarInfo[0].driver.should.not.be.empty()
			done();                    		