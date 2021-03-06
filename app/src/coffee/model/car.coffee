Immutable = require 'immutable'

Car = Immutable.Record {

	drivePic: '' # 司机头像
	name: '' # 车主名
	driver:'' # 司机名
	remark: 0 # 司机星级
	startPoint: '' # 起点
	destination: '' # 目的地
	carDesc: '' # 车辆描述
	mark:''	#备注

	# 我的车辆列表数据结构
	carNo: '' # 车牌号
	carPic: '' # 车辆图片
	mobile: '' # 联系电话
	carType: '' # 车辆类型
	carVehicle: '' # 车辆长度
	carId: ''# id
	vehicle: ''

	# 车辆详情数据结构
	id: ''
	status: '' # 车辆状态 1：空闲中，2：求货中，3：运输中 
	category: '' # 车辆类别
	heavy: '' # 可载重货
	bulky: '' # 可载泡货
	drivingImg: '' # 行驶证图片
	transportImg: '' # 道路运输许可证图片

	userId: '' # 车主Id
	wishlst: false
	goodScore: null
	certification: null

	type: null
	goodsSourceId: null
	carScore: null
	orderCarId: null
	headerImage:null

	isinvoice: null

}

module.exports = Car
