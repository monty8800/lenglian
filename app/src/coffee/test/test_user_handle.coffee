request = require './common'
should = require 'should'
config = require './config'

describe '用户以通用角色 获取相关自己相关信息 如评论 ', ->
	# it '个人认证',(done) ->
	# 	params = {
	# 		{
	# 			phone:"13899997777"		#手机号
	# 			type:"1"				#认证类型1:货主 2:车主 3:仓库
	# 			username:"laowang"		#真实姓名
	#             userId:"c413b4b93c674597a563e704090705ef"	#用户id
	# 			cardno:"12342342344234"		#身份证号
	#              #车主认证需要的字段
	#             carno：""			#车牌号码
	#             frameno：""			#车架号
	# 		}
	# 		idcardImg:file图片文件  //身份证
	# 		drivingImg:file图片文件//行驶证
	# 		taxiLicenseImg：file图片文件//营运证
	# 	}

	it '添加评论',(done) ->
		params = {
			onsetId:"7201beba475b49fd8b872e2d1493844a"		#评价人ID
			onsetRole:"2"				#评论人角色 1：货主 2:车主 3：仓库主
			targetId:"7714d0d83c7f47f4bcfac62b9a1bf101"		#目标评价人ID
			targetRole:"1"		#目标评论人角色 1：货主 2:车主 3：仓库主
			orderNo:"GC20150912581503100000182"		#订单号
			score:"8"		# 评分 5星=10 
			content:"车开得不赖"		#内容
		}
		request.post config.api.COMMENT_ADD, params, (result)->
			should.exists result
			done()

	it '查询评论',(done) ->

#TODO:
		params = {
			startNo:'0'
			pageSize:'10'
			onsetRole:"2"				#评论人角色 1：货主 2:车主 3：仓库主
			targetId:"7201beba475b49fd8b872e2d1493844a"		#目标评价人ID
		}
		request.post config.api.GET_COMMENT, params, (result)->
			should.exists result
			done()

	it '获取某货源的竞价列表', (done) ->
		params = {
			userId:'34568979687'		#	用户ID
			goodsResourceId:'yiuytb78697'		#货源ID
		}
		request.post config.api.GET_BID_ORDER_LIST, params, (result)->
			should.exists result
			done()





