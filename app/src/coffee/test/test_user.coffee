request = require './common'
should = require 'should'
config = require './config'

describe '测试用户', ->
	it '个人中心', (done)->
		userId = '7714d0d83c7f47f4bcfac62b9a1bf101'
		request.post config.api.USER_CENTER, {
			userId: userId
		}, (result)->
			should.exists result
			result.carStatus.should.be.within 0, 3
			result.certification.should.be.within 0, 2
			result.goodsStatus.should.be.within 0, 3
			#result.imgurl.should.not.be.empty()
			result.myCarCount.should.be.Number()
			result.myMessageCount.should.be.Number()
			result.myWishlistCount.should.be.Number()
			result.userId.should.equal userId
			result.usercode.should.not.be.empty()
			result.warehouseStatus.should.be.within 0, 3
			done()

	it '找回密码', (done)->
		mobile = '18513468467'
		passwd = '123456a'

		request.post config.api.SMS_CODE, {
			mobile: mobile
			type: 2
		}, (data)->
			data.should.not.be.empty()
			code = data[-6..]
			code.should.not.be.empty()
			request.post config.api.RESET_PWD, {
				usercode: mobile
				password: passwd
				mobileCode: code
			}, (result)->
				result.should.not.be.empty()
				done()

	it '修改密码', (done)->
		userId = '9cd0f23940824702b99bf74328f61f54'
		passwd = '123456a'

		request.post config.api.CHANGE_PWD, {
			userId: userId
			oldpwd: passwd
			newpwd: passwd
		}, (result)->
			result.should.not.be.empty()
			done()


	it '检测支付密码，设置/修改支付密码', (done)->
		userId = '7714d0d83c7f47f4bcfac62b9a1bf101'
		passwd = '123456'

		request.post config.api.HAS_PAY_PWD, {
			userId: userId
		}, (data)->
			data.should.not.be.empty()
			status = data.status
			status.should.be.within 0, 1

			console.log '支付密码状态', status

			request.post config.api.PAY_PWD, {
				userId: userId
				payPassword: passwd
				oldPayPwd: passwd if status is 1
			}, (result)->
				result.should.not.be.empty()
				done()

	it '找回支付密码', (done)->
		userId = '729667936d0d411daaa946e4592978f0'
		mobile = '13100000010'

		request.post config.api.SMS_CODE, {
			mobile: mobile
			type: 3
		}, (data)->
			data.should.not.be.empty()
			code = data[-6..]
			code.should.not.be.empty()
			request.post config.api.RESET_PAY_PWD, {
				password: '111111'
				usercode: mobile
				mobileCode: code
				userId: userId
			}, (result)->
				result.should.equal 1
				done()

	it '登录', (done)->
		mobile = '18513468467'
		passwd = '123456a'
		request.post config.api.LOGIN, {
			usercode: mobile
			password: passwd
		}, (result)->
			result.should.not.be.empty()
			result.carStatus.should.be.within 0, 3
			result.certification.should.be.within 0, 2
			result.goodsStatus.should.be.within 0, 3
			result.userId.should.not.be.empty()
			result.warehouseStatus.should.be.within 0, 3
			done()
