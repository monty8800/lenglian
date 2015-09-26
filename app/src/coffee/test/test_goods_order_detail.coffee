request = require './common'
should = require 'should'
config = require './config'

describe '货主订单详情', ->
	it '货主订单详情', (done)->
		params = {
			userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
			orderNo: '1' # 订单号
		}
		console.log config.api.goods_order_detail
		request.post config.api.goods_order_detail, params, (result)->
			# should.exists result
			# result.myCarInfo should.be.Array()
			# result.myCarInfo[0].driver.should.not.be.empty()
			done();      	              				