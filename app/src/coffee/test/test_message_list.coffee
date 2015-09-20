request = require './common'
should = require 'should'
config = require './config'

describe '我的消息', ->
	it '我的消息', (done) ->
		request.post config.api.message_list, {
			userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
			userRole: '1' # 角色1:货主 2:车主 3:仓库。PC可以为空。客户端必须传
		}, (result) ->
			done()     