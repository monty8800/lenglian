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