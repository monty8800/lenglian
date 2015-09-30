Immutable = require 'immutable'

Address = require 'model/address'

Goods = Immutable.Record {
	id: null #货源id
	name: null #货物名称
	type: null #货物类型 1常温，2冷藏，3冷冻，4急冻， 5深冷
	weight: '' #货物重量
	cube: ''   #货物体积
	packType: ''  #包装类型
	photo: null  #货物图片
	installMinTime: null #最早装车时间
	installMaxTime: null  #最晚装车时间
	arriveMinTime: null  #最早到货时间
	arriveMaxTime: null #最迟到货时间
	refrigeration: 1 #需要冷库 1不需要，2需要，3目的地需要，4起始地需要
	priceType: 1 #价格类型 1一口价， 2竞价
	price: null
	payType: 1 #支付方式 1货到付款， 2回单付款， 3预付款
	prePay: null #预付款
	invoice: 1 #是否需要发票 1需要 2不需要

	sender: null #发货人
	senderMobile: null #发货人电话
	reciver: null #收货人
	reciverMobile: null #收货人电话

	remark: null #备注
}

module.exports = Goods