request = require './common'
should = require 'should'
config = require './config'

describe '仓库订单详情', ->
	it '仓库订单详情', (done)->
		url = config.api.store_order_detail
		request.post url, {
			userId: 'c413b4b93c674597a563e704090705ef'
			orderNo: '9791c2dd2ff14a35bd74137a7269b936'
		}, (result)->
			done()


