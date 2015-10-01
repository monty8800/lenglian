Immutable = require 'immutable'

Warehouse = Immutable.Record {
	id:null 			#仓库ID
	name:null 			#仓库名称
	address:null 		#仓库名称
	provinceName:null 	#地址 省
	provinceId:null		#省 ID
	cityName:null 		#地址 市
	cityId:null			#市ID
	areaName:null		#地址 区
	areaId:null			#区ID
	street:null			#地址 街道
	status:0   			# 0-空闲中  1-已发布 2-使用中
	styleType:0 		#  驶入式、横梁式、平推式、自动立体货架式
	imageUrl:null			#图片
	invoice:0 			# 0-不提供发票 1-提供发票
	rentTime:null		#租赁时间
	contact:null  		#联系人姓名
	contactTel:null 	#联系人电话
	latitude:null		#坐标 纬度
	longitude:null		#坐标 经度
	remark:null			#仓库备注
	updateTime:null		#信息更新时间
	warehouseProperty:[]	#仓库各种属性的数组 

	# volume:0  			# 容量 单位 m³
	# acreageTotal:0  	#总面积 单位 ㎡
	# temperatureType: null #温度类型
	# #acreageNormal:0 	#常温面积 单位 ㎡
	# #acreageCold:0   	#冷藏面积 单位 ㎡
	# price:0 			#价格 单位待定 ¥100/天 ¥100/托  
	# increaseServe:null  #城配 仓配 金融

}
module.exports = Warehouse


# "warehouseProperty": [
#       {
#         "attribute": "1",
#         "attributeName": "驶入式",
#         "id": "c5b5fb911c8d46c69f60c1385df17a09",
#         "type": "1",
#         "typeName": "仓库类型"
#       },
#       {
#         "attribute": "1",
#         "attributeName": "横梁式",
#         "id": "8618613881064b97995473e1b1d5ee2f",
#         "type": "1",
#         "typeName": "仓库类型"
#       },
#       {
#         "attribute": "1",
#         "attributeName": "城配",
#         "id": "ce38bc3d49cf4bcc95708bbb459f80a3",
#         "type": "2",
#         "typeName": "仓库增值服务"
#       },
#       {
#         "attribute": "1",
#         "attributeName": "常温",
#         "id": "1a16c93dc7594fa5800b34d14ff851fe",
#         "type": "3",
#         "typeName": "仓库面积",
#         "value": "2312"
#       },
#       {
#         "attribute": "1",
#         "attributeName": "/天/平",
#         "id": "5843149ed1474253bb5e4d94fce69db3",
#         "type": "4",
#         "typeName": "价格",
#         "value": "12"
#       }
#     ]