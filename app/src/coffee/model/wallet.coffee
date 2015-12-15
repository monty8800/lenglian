Immutable = require 'immutable'

Wallet = Immutable.Record {
	money:0					#余额
	score:0					#积分
	level:0					#会员等级
	bankCardsList:[]		#银行卡列表

	amount: 0
	createTime: null
	orderNo: null
	type: 0
	userMobile: null
	state: null
	orderId: null

}
module.exports = Wallet