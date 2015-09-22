request = require './common'
should = require 'should'
config = require './config'

describe '短信验证码', ->
	typeList = [
		{id: 1, title: '注册', mobile: '18596669998'},
		{id: 2, title: '重置密码', mobile: '18513468467'},
		{id: 3, title: '重置支付密码', mobile: '18513468467'}
	]

	typeList.map (type, i)->
		it type.title, (done)->
			url = config.api.SMS_CODE
			request.post url, {
				mobile: type.mobile
				type: type.id
			}, (result)->
				done()