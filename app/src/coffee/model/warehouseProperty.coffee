Immutable = require 'immutable'

WarehouseProperty = Immutable.Record {
	type:null	#1：仓库类型；  2 仓库配套服务； 3：仓库面积; 4 价格
	attribute:null #
	value:'' 		#
	typeName:null	#
	attributeName:null	#
	valueTwo:''
}
module.exports = WarehouseProperty

