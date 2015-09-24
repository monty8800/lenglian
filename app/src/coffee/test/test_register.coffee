request = require './common'
should = require 'should'
config = require './config'

describe '测试注册', ->
	it '注册', (done)->
		mobile = '13888888831' # 18513468467
		request.post config.api.SMS_CODE, {
			mobile: mobile
			type: 1 #注册
		}, (result)->
			code = result[-6..]
			console.log '验证码:', code

			request.post config.api.REGISTER, {
				usercode: mobile
				mobileCode: code
				password: '123456a'
			}, (result)->
				result.userId.should.not.be.empty()
				done()
