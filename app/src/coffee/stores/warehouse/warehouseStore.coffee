'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
User = require 'model/user'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
WarehouseModel = require 'model/warehouseModel'
WarehousePropertyModel = require 'model/warehouseProperty'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'

_warehouse = new WarehouseModel

_warehouseList = Immutable.List()

# 搜索仓库结果
_warehouseSearchResult = []

# 仓库找货 搜索结果
_warehouseSearchGoodsResult = []

_showType = '1'

getWarehouseList = (status,pageNow,pageSize)->
	_showType = status
	console.log '获取仓库列表 status='+status+' pageNow='+pageNow+' pageSize='+pageSize + '__showType='+_showType
	user = UserStore.getUser()
	Http.post Constants.api.GET_WAREHOUSE,{
		userId:user.id
		status:status
		pageNow:pageNow
		pageSize:pageSize
	},(data)->
		warehouses = data.myWarehouse
		if pageNow is '0'
			_warehouseList = []

		for i in warehouses
			warehouseModel = new WarehouseModel
			warehouseModel = warehouseModel.set 'provinceName',warehouses[i].provinceName
			warehouseModel = warehouseModel.set 'cityName',warehouses[i].cityName
			warehouseModel = warehouseModel.set 'areaName',warehouses[i].areaName
			warehouseModel = warehouseModel.set 'name',warehouses[i].name
			_warehouseList = _warehouseList.push warehouseModel

		WarehouseStore.emitChange 'getMyWarehouseList'
	,null,true


getDetail = (warehouseId) ->
	user = UserStore.getUser()

	Http.post Constants.api.WAREHOUSE_DETAIL,{
		userId:user.id
		warehouseId:warehouseId
	},(data)->
		warehouseLoad = data.warehouseLoad
		_warehouse = _warehouse.set 'id', warehouseLoad.id 			#仓库ID
		_warehouse = _warehouse.set 'name', warehouseLoad .name			#仓库名称
		_warehouse = _warehouse.set 'address', warehouseLoad.address		#仓库名称
		_warehouse = _warehouse.set 'provinceName', warehouseLoad.provinceName 	#地址 省
		_warehouse = _warehouse.set 'provinceId', warehouseLoad.provinceId		#省 ID
		_warehouse = _warehouse.set 'cityName', warehouseLoad.cityName 		#地址 市
		_warehouse = _warehouse.set 'cityId', warehouseLoad.cityId			#市ID
		_warehouse = _warehouse.set 'areaName', warehouseLoad.areaName		#地址 区
		_warehouse = _warehouse.set 'areaId', warehouseLoad.areaId			#区ID
		_warehouse = _warehouse.set 'street', warehouseLoad.street			#地址 街道
		_warehouse = _warehouse.set 'status', warehouseLoad.status  			# 0-空闲中  1-已发布 2-使用中
		_warehouse = _warehouse.set 'styleType', warehouseLoad.styleType		#  驶入式、横梁式、平推式、自动立体货架式
		_warehouse = _warehouse.set 'imageUrl', warehouseLoad.imageUrl			#图片
		_warehouse = _warehouse.set 'invoice', warehouseLoad.invoice			# 0-不提供发票 1-提供发票
		_warehouse = _warehouse.set 'volume', warehouseLoad.volume  			# 容量 单位 m³
		_warehouse = _warehouse.set 'acreageTotal', warehouseLoad.acreageTotal  	#总面积 单位 ㎡
		_warehouse = _warehouse.set 'temperatureType', warehouseLoad.temperatureType #温度类型
		_warehouse = _warehouse.set '#acreageNormal', warehouseLoad.acreageNormal 	#常温面积 单位 ㎡
		_warehouse = _warehouse.set '#acreageCold', warehouseLoad.acreageCold   	#冷藏面积 单位 ㎡
		_warehouse = _warehouse.set 'contact', warehouseLoad.contact  		#联系人姓名
		_warehouse = _warehouse.set 'contactTel', warehouseLoad.contactTel 	#联系人电话
		_warehouse = _warehouse.set 'price', warehouseLoad.price			#价格 单位待定 ¥100/天 ¥100/托  
		_warehouse = _warehouse.set 'increaseServe', warehouseLoad.increaseServe  #城配 仓配 金融
		_warehouse = _warehouse.set 'latitude', warehouseLoad.latitude		#坐标 纬度
		_warehouse = _warehouse.set 'longitude', warehouseLoad.longitude	#坐标 经度
		_warehouse = _warehouse.set 'remark', warehouseLoad.remark			#仓库备注
		_warehouse = _warehouse.set 'updateTime', warehouseLoad.updateTime		#信息更新时间

		propertyArr = warehouseLoad.warehouseProperty
		tempArr = []
		for i in propertyArr
			propertyModel = new WarehousePropertyModel
			propertyModel = propertyModel.set 'type',propertyArr[i].type
			propertyModel = propertyModel.set 'attribute',propertyArr[i].attribute
			propertyModel = propertyModel.set 'value',propertyArr[i].value
			propertyModel = propertyModel.set 'typeName',propertyArr[i].typeName
			propertyModel = propertyModel.set 'attributeName',propertyArr[i].attributeName
			tempArr.push propertyModel
		_warehouse = _warehouse.set 'warehouseProperty', tempArr	#仓库各种属性的数组 
		
		WarehouseStore.emitChange 'getDetailWithId'
	,null,true

searchWarehouse = (startNo,pageSize)->
	console.log '搜索获取仓库  star+++tNo='+startNo+' pageSize='+pageSize
	Http.post Constants.api.SEARCH_WAREHOUSE,{
		startNo:startNo
		pageSize:pageSize
	},(data)->
		Plugin.loading.hide()
		_warehouseSearchResult = data	#搜索仓库 返回的data本身就是数组
		WarehouseStore.emitChange 'searchWarehouse'
	,null,true

warehouseSearchGoods = (startNo,pageSize)->
	Http.post Constants.api.WAREHOUSE_SEARCH_GOODS,{
		startNo:startNo
		pageSize:pageSize
	},(data)->
		_warehouseSearchGoodsResult = data.goods
		WarehouseStore.emitChange 'warehouseSearchGoods'
	,null,true

WarehouseStore = assign BaseStore, {
	getWarehouseList: ()->
		_warehouseList
	getShowType :->
		_showType
	getDetail: ()->
		_warehouse
	getWarehouseSearchResult: ()->
		_warehouseSearchResult
	getWarehouseSearchGoodsResult: ()->
		_warehouseSearchGoodsResult
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_WAREHOUSE then getWarehouseList(action.status,action.pageNow,action.pageSize)
		when Constants.actionType.WAREHOUSE_DETAIL then getDetail(action.warehouseId)
		when Constants.actionType.SEARCH_WAREHOUSE then searchWarehouse(action.startNo,action.pageSize)
		when Constants.actionType.WAREHOUSE_SEARCH_GOODS then warehouseSearchGoods(action.startNo,action.pageSize)


module.exports = WarehouseStore
