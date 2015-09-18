Immutable = require 'immutable'

Car = Immutable.Record {
	drivePic: '' # 司机头像
	name: '' # 司机名
	remark: 0 # 司机星级
	startPoint: '' # 起点
	destination: '' # 目的地
	carDesc: '' # 车辆描述


	# 我的车辆列表数据结构
	carNo: '' # 车牌号
	carPic: '' # 车辆图片
	mobile: '' # 联系电话
	carType: '' # 车辆类型
	carVehicle: '' # 车辆长度


}

module.exports = Car