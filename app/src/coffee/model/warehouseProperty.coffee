Immutable = require 'immutable'

WarehouseProperty = Immutable.Record {
	type:null	#1：仓库类型；  2 仓库增值服务； 3：仓库面积; 4 价格
	attribute:null #
	value:null 		#
	typeName:null	#
	attributeName:null	#
}
module.exports = WarehouseProperty


# warehouseProperty:[
# 	#1：仓库类型；
# 		#仓库类型 1：驶入式 2：横梁式 3：平推式 4：自动立体货架式， 
# 	#2 仓库增值服务；
# 		# 增值服务 1：城配 2：仓配 3：金融 ，
# 	#3：仓库面积;
# 		# 仓库面积 1：常温 2：冷藏 3：冷冻 4：急冻 5：深冷，
# 	#4 价格
# 		# 价格 1：天/托 2：天/平
# 	{
# 	   	type:"1"		
# 	   	attribute:"1"	 
# 	   	value:""				#文本框需要输入的值
# 	   	typeName:"仓库类型"		#跟type对应中文
# 	   	attributeName:"驶入式"	#跟attribute对应中文
# 	}
# 	{
# 	   	type:"2"		
# 	   	attribute:"1"	 
# 	   	value:""				#文本框需要输入的值
# 	   	typeName:"仓库增值服务"	#跟type对应中文
# 	   	attributeName:"城配"		#跟attribute对应中文
# 	}
# 	{
# 	   	type:"2"		
# 	   	attribute:"2"	 
# 	   	value:""				#文本框需要输入的值
# 	   	typeName:"仓库增值服务"	#跟type对应中文
# 	   	attributeName:"仓配"		#跟attribute对应中文
# 	}
# 	{
# 	   	type:"3"		
# 	   	attribute:"1"	 
# 	   	value:"1000"			#文本框需要输入的值
# 	   	typeName:"仓库面积"		#跟type对应中文
# 	   	attributeName:"常温"		#跟attribute对应中文
# 	}
# 	{
# 	   	type:"3"		
# 	   	attribute:"3"	 
# 	   	value:"2000"			#文本框需要输入的值
# 	   	typeName:"仓库面积"		#跟type对应中文
# 	   	attributeName:"冷冻"		#跟attribute对应中文
# 	}
# 	{
# 	   	type:"4"		
# 	   	attribute:"2"	 
# 	   	value:""				#文本框需要输入的值
# 	   	typeName:"价格"			#跟type对应中文
# 	   	attributeName:"天/平"	#跟attribute对应中文
# 	}            
# ]
