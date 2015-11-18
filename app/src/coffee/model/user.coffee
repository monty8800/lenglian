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

	lastLogin: null #上次登陆时间
	lastUpdate: null #上次更新时间

	#认证需要的相关图片
	carPic: null #车辆图片
	license: null #驾驶证图片地址
	idCard: null #身份证图片地址
	operationLicense: null #运营证图片地址
	businessLicense: null #营业执照图片地址
	companyPic: null #门头照片地址
	transLicensePic: null # 道路运输许可证照片


	#认证相关字段，本地缓存用，再次认证带过去
	idCardNo: null #身份证号码
	carNo: null #车牌号
	vinNo: null #车架号

	businessLicenseNo: null #营业执照号码
	transLicenseNo: null #道路运输许可证号码
	organizingCode: null #组织机构代码

	address: null #公司地址
	street: null #公司详细地址
	tel: null #公司电话

	personalGoodsStatus: null #0审核中， 1审核通过， 2审核驳回
	personalGoodsCause: null
	personalCarStatus: null
	personalCarCause: null
	personalWarehouseStatus: null
	personalWarehouseCause: null

	enterpriseGoodsStatus: null
	enterpriseGoodsCause: null
	enterpriseCarStatus: null
	enterpriseCarCause: null
	enterpriseWarehouseStatus: null
	enterpriseWarehouseCause: null

}
module.exports = User