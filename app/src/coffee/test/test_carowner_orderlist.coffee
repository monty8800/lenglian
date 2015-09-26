request = require './common'
should = require 'should'
config = require './config'

describe '车主订单列表', ->
	it '车主订单列表', (done)->
		params = {
			carPersonUserId: '7714d0d83c7f47f4bcfac62b9a1bf101',
			pageNow: 1,
			pageSize: 10,
			orderState: '' # 全部空 订单状态 1:洽谈中 2:待付款 3:已付款 4:待评价 5:已取消
		}
		request.post config.api.carowner_order_list, params, (result)->
			should.exists result
			# result.myCarInfo should.be.Array()
			# result.myCarInfo[0].driver.should.not.be.empty()
			done();                     	