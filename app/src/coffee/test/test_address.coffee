request = require './common'
should = require 'should'
config = require './config'

describe '地址', ->
	it '我的地址列表', (done)->
		userId = 'c413b4b93c674597a563e704090705ef'
		request.post config.api.ADDR_LIST, {
			userId: userId
		}, (result)->
			result.should.not.be.empty()
			done()