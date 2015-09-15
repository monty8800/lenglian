Immutable = require 'immutable'

User = Immutable.Record {
	mobile: null #手机号
	passwd: null #密码
	id: null  #用户id
	orderDoneCount: 0 #成交订单数
	orderBreakCount: 0 #违约订单数
	highPraiseRate: '100%' #好评率
	name: null #用户真实姓名
	company: null #公司名字
}
module.exports = User