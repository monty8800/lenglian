Immutable = require 'immutable'

Order = Immutable.Record {

	carPersonName: null # 车主姓名
	carPersonUserId: null # 车主用户ID
	destination: null # 目的地
	goodSsourceId: null # 货源id
	goodsName: null # 货物名称
	goodSsourceId: null # 货主userId
	goodsPersonName: null # 货主名称
	goodsPersonScore: null # 货主名称
	goodsState: null # 订单状态为洽谈中。车主订单状态(1:等待货主确认, 2:车主是否接受货主的货,3:是否可以竞价)
	goodsType: null # 货物类型
	goodsWeight: 0 # 货物重量
	orderNo: null # 订单号
	orderState: 0 # 订单状态 1:洽谈中 2:待付款 3:已付款 4:待评价 5:已取消
	orderType: null # 订单类型 CG:车货 GC:货车 WG:货仓 GW:仓货 
	payType: 0 # 支付方式 1：货到付款（线下）2：回单付款（线下） 3：预付款（线上）
	price: null # 价格
	priceType: 0 # 价格类型
	restBidding: 0 # 剩余竞价次数  价格类型为竞价出现
	setOut: null # 始发地
	version: null # 版本号
	advance: null # 预付款金额
	payState: 0 # 支付状态
	goodsPersonHeadPic: null # 货主头像
	goodsDesc: null # 货物名称

}

module.exports = Order