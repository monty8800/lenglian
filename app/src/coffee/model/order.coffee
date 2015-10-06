Immutable = require 'immutable'

Order = Immutable.Record {

	# 车主订单
	carPersonName: null # 车主姓名
	carPersonUserId: null # 车主用户ID
	destination: null # 目的地
	goodSsourceId: null # 货源id
	goodsName: null # 货物名称
	# goodSsourceId: null # 货主userId
	goodsPersonName: null # 货主名称
	goodsPersonScore: null # 货主等级
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
	goodsDesc: null # 货物描述
	goodsPersonUserId: null

	# 货主订单
	acceptMode: null
	advance: null
	basePrice: null
	bidEnd: null
	bidName: null
	createTime: null
	fromCityName: null
	fromCountyName: null
	fromProvinceName: null
	goodsCubic: null
	# goodsName: null 通用
	# goodsPersonUserId: null 通用
	# goodsSourceId: null 通用
	# goodsType: null 通用
	# goodsWeight: null 通用
	# orderNo: null 通用
	# orderState: 0 通用
	# orderType: 0 通用
	# payType: 0  通用
	# price: null  通用
	# priceType: 0  通用
	toCityName: null
	toCountyName: null
	toProvinceName: null
	userHeadPic: null
	userId: null
	userMobile: null
	userName: null
	userScore: 0
	warehouseName: null
	warehousePriceSquare: null
	warehousePriceTorr: null
	goodsSourceId: null


	# 仓库订单
	fromCityCode: null
	# fromCityName: null
	fromCountyCode: null
	# fromCountyName: null
	fromProvinceCode: null
	# fromProvinceName: null
	goodsCreateTime: null
	# goodsCubic: null
	goodsId: null
	# goodsName: null
	goodsPackingType: null
	goodsPersonAuthMode: null
	goodsPersonMobile: null
	# goodsPersonName: null
	# goodsPersonScore: null
	# goodsPersonUserId: null
	goodsPic: null
	goodsRouteList: null
	# goodsSourceId: null
	# goodsType: null
	isAccept: null
	isInvoice: null
	loadingDate: null
	orderNo: null
	orderState: null
	orderType: null
	payType: null
	price: null
	priceType: null
	roleMode: null
	shipper: null
	shipperMobile: null
	sourceMobile: null
	sourceMode: null
	toCityCode: null
	toCityName: null
	toCountyCode: null
	toCountyName: null
	toProvinceCode: null
	toProvinceName: null
	warehouseArea: null
	warehouseDetailedAddress: null
	warehouseId: null
	warehouseIsAccept: null
	warehouseIsInvoice: null
	warehouseLinkMobile: null
	warehouseLinkName: null
	warehouseName: null
	warehouseOrderid: null
	warehousePersonAuthMode: null
	warehousePersonMobile: null
	warehousePersonName: null
	warehousePersonScore: null
	warehousePersonUserId: null
	warehousePic: null
	warehousePlace: null
	warehousePriceSquare: null
	warehouseRemark: null
	warehouseRoleMode: null
	warehouseServices: null
	warehouseSourceMobile: null
	warehouseSourceMode: null
}

module.exports = Order