request = require './common'
should = require 'should'
config = require './config'

describe '测试用户', ->
	# it '个人中心', (done)->
	# 	userId = '7714d0d83c7f47f4bcfac62b9a1bf101'
	# 	request.post config.api.USER_CENTER, {
	# 		userId: userId
	# 	}, (result)->
	# 		should.exists result
	# 		result.carStatus.should.be.within 0, 3
	# 		result.certification.should.be.within 0, 2
	# 		result.goodsStatus.should.be.within 0, 3
	# 		#result.imgurl.should.not.be.empty()
	# 		result.myCarCount.should.be.Number()
	# 		result.myMessageCount.should.be.Number()
	# 		result.myWishlistCount.should.be.Number()
	# 		result.userId.should.equal userId
	# 		result.usercode.should.not.be.empty()
	# 		result.warehouseStatus.should.be.within 0, 3
	# 		result.isPayStatus.should.be.within 0, 1
	# 		result.balance.should.be.Number()
	# 		done()

	# it '找回密码', (done)->
	# 	mobile = '18513468467'
	# 	passwd = '123456'

	# 	request.post config.api.SMS_CODE, {
	# 		mobile: mobile
	# 		type: 2	
	# 	}, (data)->
	# 		data.should.not.be.empty()
	# 		code = data[-6..]
	# 		code.should.not.be.empty()
	# 		request.post config.api.RESET_PWD, {
	# 			usercode: mobile
	# 			password: passwd
	# 			mobileCode: code
	# 		}, (result)->
	# 			result.should.not.be.empty()
	# 			done()

	# it '修改密码', (done)->
	# 	userId = '9cd0f23940824702b99bf74328f61f54'
	# 	passwd = '12345a'

	# 	request.postFile config.api.CHANGE_PWD, {
	# 		userId: userId
	# 		oldpwd: passwd
	# 		newpwd: passwd
	# 	}, (result)->
	# 		result.should.not.be.empty()
	# 		done()


	# it '检测支付密码，设置/修改支付密码', (done)->
	# 	userId = '7714d0d83c7f47f4bcfac62b9a1bf101'
	# 	passwd = '123456'

	# 	request.post config.api.HAS_PAY_PWD, {
	# 		userId: userId
	# 	}, (data)->
	# 		data.should.not.be.empty()
	# 		status = data.status
	# 		status.should.be.within 0, 1

	# 		console.log '支付密码状态', status

	# 		request.post config.api.PAY_PWD, {
	# 			userId: userId
	# 			payPassword: passwd
	# 			oldPayPwd: passwd if status is 1
	# 		}, (result)->
	# 			result.should.not.be.empty()
	# 			done()

	# it '找回支付密码', (done)->
	# 	userId = '729667936d0d411daaa946e4592978f0'
	# 	mobile = '13100000010'

	# 	request.post config.api.SMS_CODE, {
	# 		mobile: mobile
	# 		type: 3
	# 	}, (data)->
	# 		data.should.not.be.empty()
	# 		code = data[-6..]
	# 		code.should.not.be.empty()
	# 		request.post config.api.RESET_PAY_PWD, {
	# 			password: '111111'
	# 			usercode: mobile
	# 			mobileCode: code
	# 			userId: userId
	# 		}, (result)->
	# 			result.should.equal 1
	# 			done()

	# it '登录', (done)->
	# 	mobile = '18513468467'
	# 	passwd = '123456a'
	# 	request.post config.api.LOGIN, {
	# 		usercode: mobile
	# 		password: passwd
	# 	}, (result)->
	# 		result.should.not.be.empty()
	# 		result.carStatus.should.be.within 0, 3
	# 		result.certification.should.be.within 0, 2
	# 		result.goodsStatus.should.be.within 0, 3
	# 		result.userId.should.not.be.empty()
	# 		result.warehouseStatus.should.be.within 0, 3
	# 		done()


	# it '添加评论',(done) ->
	# 	params = {
	# 		onsetId:"4671d0d8c37f47f4bcfa2323222bf102"		#手机号
	# 		onsetRole:"2"				#评论人角色 1：货主 2:车主 3：仓库主
	# 		targetId:"7714d0d83c7f47f4bcfac62b9a1bf101"		#目标评价人ID
	# 		targetRole:"1"		#目标评论人角色 1：货主 2:车主 3：仓库主
	# 		orderNo:"GC20150912581503100000182"		#订单号
	# 		score:"10"		# 评分 5星=10 
	# 		content:"fegsgesgdgsegse"		#内容
	# 	}
	# 	request.post config.api.LOGIN, params, (result)->
	# 		result.should.not.be.empty()
	# 		result.carStatus.should.be.within 0, 3
	# 		result.certification.should.be.within 0, 2
	# 		result.goodsStatus.should.be.within 0, 3
	# 		result.userId.should.not.be.empty()
	# 		result.warehouseStatus.should.be.within 0, 3
	# 		done()

	it '修改头像',(done) ->
		files = [
			{
				filed: 'file'
				path: 'src/images/car-02.jpg'
				name: 'avatar.jpg'    
			}
		]

		request.postFile config.api.SET_AVATAR, {userId: '50819ab3c0954f828d0851da576cbc31'}, files, (data)->
			data.should.equal 1
			done()





