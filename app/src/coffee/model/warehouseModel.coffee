Immutable = require 'immutable'

Warehouse = Immutable.Record {
	id:null 			#仓库ID
	name:null 			#仓库名称
	address:null 		#仓库名称
	provinceName:null 	#地址 省
	cityName:null 		#地址 市
	areaName:null		#地址 区
	street:null			#地址 街道
	status:0   			# 0-空闲中  1-已发布 2-使用中
	styleType:0 		#  驶入式、横梁式、平推式、自动立体货架式
	image:null			#图片
	invoice:0 			# 0-不提供发票 1-提供发票
	volume:0  			# 容量 单位 m³
	acreageTotal:0  	#总面积 单位 ㎡
	temperatureType: null #温度类型
	#acreageNormal:0 	#常温面积 单位 ㎡
	#acreageCold:0   	#冷藏面积 单位 ㎡
	contacterName:null  #联系人姓名
	contacterTel:null 	#联系人电话
	price:0 			#价格 单位待定 ¥100/天 ¥100/托  
	increaseServe:null  #城配 仓配 金融
	
}
module.exports = Warehouse