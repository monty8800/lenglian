Immutable = require 'immutable'

Address = require 'model/address'

Goods = Immutable.Record {
	id: null #货id
	userHeaderImageUrl:null	#用户头像
	goodsResourceId:null	#货源ID
	name: null 				#货物名称
	fromProvinceName:null	#起点 省
	fromCityName:null		#起点 市
	fromAreaName:null 		#起点 区
	fromStreet:null			#起点 街道
	fromLat:null			#起点 坐标
	fromLng:null			#起点 坐标
	toProvinceName: null	#终点 省
	toCityName: null 		#终点 市
	toAreaName: null		#终点 区
	toStreet:null			#终点 街道
	toLat: null				#终点 坐标
	toLng: null 			#终点 坐标

	type: null 				#货物类型 1常温，2冷藏，3冷冻，4急冻， 5深冷
	weight: '' 				#货物重量
	packType: '' 			 #包装类型
	imageUrl:null			#图片地址
	photo: null  			#货物图片	

	installMinTime: null		#最早装车时间
	installMaxTime: null  		#最晚装车时间
	arriveMinTime: null  		#最早到货时间
	arriveMaxTime: null 		#最迟到货时间

	installStime:null			#装车开始时间
	installEtime:null			#装车结束时间
	arrivalStime:null			#到货开始时间
	arrivalEtime:null			#到货结束时间

	refrigeration: 1 			#需要冷库 1不需要，2需要，3目的地需要，4起始地需要
	resourceStatus:null			#货源状态 1-求车(库)中 2-有人响应 3-已成交
	priceType:1 				#价格类型 1一口价， 2竞价
	price: null
	payType:1					#支付方式 1货到付款， 2回单付款， 3预付款
	prePay: null 				#预付款
	invoice:1 					#是否需要发票 1需要 2不需要

	sender: null 				#发货人
	senderMobile: null			#发货人电话
	receiver: null 				#收货人
	receiverMobile: null 		#收货人电话
	mjGoodsRoutes:[]			#途经地
	remark: null 				#备注
	wishlst:false				#是否被关注
	stars:0						#评价 星级
	goodsType:1					#货物类型(1:常温、2:冷藏、3:冷冻、4:急冻、5:深冷)

	cube: ''   				#货物体积

	remark: null #备注

	#搜索返回的冗余字段
	canBid: 1 #是否可以竞价 1可以 2不可以
	certification: 0 #认证类型 0 未认证 1个人 2公司
	userAvatar: null #用户头像
	userId: null #用户id
	userName: null #用户姓名
	userScore: 0 #用户积分


}

module.exports = Goods