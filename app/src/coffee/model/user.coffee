Immutable = require 'immutable'

User = Immutable.Record {
	mobile: null #手机号
	passwd: null #密码
	avatar: null #头像
	id: null  #用户id
	orderDoneCount: 0 #成交订单数
	orderBreakCount: 0 #违约订单数
	highPraiseRate: '100%' #好评率
	name: null #用户真实姓名
	company: null #公司名字
	certification: 0 #认证类型 1:个人 2：企业 默认是 0（未认证）
	carStatus: 0 #0未认证车主，1认证, 2认证中，3审核驳回
	carCause: null #车主驳回原因
	goodsStatus: 0 #0未认证货主，1认证, 2认证中，3审核驳回
	goodsCause: null #货主驳回原因
	warehouseStatus: 0 #0未认证仓库主，1认证 ,2认证中，3审核驳回
	warehouseCause: null #仓库主驳回原因
	carCount: 0 #车辆数
	messageCount: 0 #消息数
	warehouseCount: 0 #消息数
	hasPayPwd: 0 #是否有支付密码，0 未设置， 1 已设置
	balance: 0 #账户余额

	#认证需要的相关图片
	license: null #驾驶证图片地址
	idCard: null #身份证图片地址
	operationLicense: null #运营证图片地址
	businessLicense: null #营业执照图片地址
	companyPic: null #门头照片地址
}
module.exports = User