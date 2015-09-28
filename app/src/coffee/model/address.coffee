Immutable = require 'immutable'

Address = Immutable.Record {
	id: null # 地址id
	userId: null # 用户id
	street: null # 详细地址
	provinceId: null # 省id
	cityId: null #城市id
	areaId: null #区id
	provinceName: null #省
	cityName: null #市
	areaName: null #区
	
	#定位的缓存
	lati: null
	longi: null
}
module.exports = Address