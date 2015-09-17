Immutable = require 'immutable'

Car = Immutable.Record {
	pic: '' # 司机头像
	name: '' # 司机名
	remark: 0 # 司机星级
	startPoint: '' # 起点
	destination: '' # 目的地
	carDesc: '' # 车辆描述
}

module.exports = Car