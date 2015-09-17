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
	certification: 0 #认证类型 1:个人 2：企业 默认是 0（未认证）
	carStatus: 0 #0未认证车主，1认证
	carCause: null #车主驳回原因
	goodsStatus: 0 #0未认证货主，1认证
	goodsCause: null #货主驳回原因
	warehouseStatus: 0 #0未认证仓库主，1认证
	warehouseCause: null #仓库主驳回原因
}
module.exports = User