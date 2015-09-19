Immutable = require 'immutable'

Address = Immutable.Record {
	id: null # 地址id
	userId: null # 用户id
	street: null # 详细地址
	provinceId: 0 # 
	cityId: 0
	areaId: 0
	provinceName: null
	cityName: null
	areaName: null
	
}
module.exports = Address