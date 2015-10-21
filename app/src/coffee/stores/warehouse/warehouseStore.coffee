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
_searchWarehouseDetail = new WarehouseModel
_warehouseList = []

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
		DB.remove 'shouldWarehouseListReload'
		warehouses = data.myWarehouse
		if pageNow is '1'
			_warehouseList = []
		
		for aWarehouse in warehouses
			warehouseModel = new WarehouseModel
			warehouseModel = warehouseModel.set 'provinceName',aWarehouse.provinceName
			warehouseModel = warehouseModel.set 'cityName',aWarehouse.cityName
			warehouseModel = warehouseModel.set 'areaName',aWarehouse.areaName
			warehouseModel = warehouseModel.set 'name',aWarehouse.name
			warehouseModel = warehouseModel.set 'street',aWarehouse.street
			warehouseModel = warehouseModel.set 'id',aWarehouse.id
			
			_warehouseList.push warehouseModel

		WarehouseStore.emitChange 'getMyWarehouseList'
	, null
	, false

window.tryReloadWarehousList = ()->
	shouldReloadWarehouseList = DB.get 'shouldWarehouseListReload'
	if (parseInt shouldReloadWarehouseList) is 1
		getWarehouseList _showType,'1','10'
		console.log '仓库列表刷新......'	

window.addWarehouseSucc = ()->
	#  1  应该刷新仓库列表 刷新后del
	DB.put 'shouldWarehouseListReload',1

window.doWarehouseSearchGoods = ->
	WarehouseStore.emitChange 'do:warehouse:search:goods'

window.doSearchWarehouse = ->
	WarehouseStore.emitChange 'do:search:warehouse'



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
		_warehouse = _warehouse.set 'imageUrl', warehouseLoad.imgurl			#图片
		_warehouse = _warehouse.set 'invoice', warehouseLoad.isinvoice			# 0-不提供发票 1-提供发票
		_warehouse = _warehouse.set 'contact', warehouseLoad.contacts  		#联系人姓名
		_warehouse = _warehouse.set 'contactTel', warehouseLoad.phone 	#联系人电话
		_warehouse = _warehouse.set 'latitude', warehouseLoad.latitude		#坐标 纬度
		_warehouse = _warehouse.set 'longitude', warehouseLoad.longitude	#坐标 经度
		_warehouse = _warehouse.set 'remark', warehouseLoad.remark			#仓库备注
		_warehouse = _warehouse.set 'updateTime', warehouseLoad.updateTime		#信息更新时间

		# _warehouse = _warehouse.set 'volume', warehouseLoad.volume  			# 容量 单位 m³
		# _warehouse = _warehouse.set 'acreageTotal', warehouseLoad.acreageTotal  	#总面积 单位 ㎡
		# _warehouse = _warehouse.set 'temperatureType', warehouseLoad.temperatureType #温度类型
		# _warehouse = _warehouse.set '#acreageNormal', warehouseLoad.acreageNormal 	#常温面积 单位 ㎡
		# _warehouse = _warehouse.set '#acreageCold', warehouseLoad.acreageCold   	#冷藏面积 单位 ㎡
		# _warehouse = _warehouse.set 'price', warehouseLoad.price			#价格 单位待定 ¥100/天 ¥100/托  
		# _warehouse = _warehouse.set 'increaseServe', warehouseLoad.increaseServe  #城配 仓配 金融
		
		propertyArr = warehouseLoad.warehouseProperty
		tempArr = []
		for prop in propertyArr
			propertyModel = new WarehousePropertyModel
			propertyModel = propertyModel.set 'type',prop.type
			propertyModel = propertyModel.set 'attribute',prop.attribute
			propertyModel = propertyModel.set 'value',prop.value
			propertyModel = propertyModel.set 'typeName',prop.typeName
			propertyModel = propertyModel.set 'attributeName',prop.attributeName
			tempArr.push propertyModel
		_warehouse = _warehouse.set 'warehouseProperty', tempArr	#仓库各种属性的数组 
		
		WarehouseStore.emitChange 'getWarehouseDetailWithId'

getSearchWarehouseDetail = (warehouseId,focusid) ->
	user = UserStore.getUser()
	Http.post Constants.api.WAREHOUSE_DETAIL,{
		userId:user.id
		warehouseId:warehouseId
		focusid:focusid
	},(data)->
		warehouseLoad = data.warehouseLoad
		_searchWarehouseDetail = _searchWarehouseDetail.set 'id', warehouseLoad?.id 			#仓库ID
		_searchWarehouseDetail = _searchWarehouseDetail.set 'name', warehouseLoad?.name			#仓库名称
		_searchWarehouseDetail = _searchWarehouseDetail.set 'address', warehouseLoad?.address		#仓库名称
		_searchWarehouseDetail = _searchWarehouseDetail.set 'provinceName', warehouseLoad?.provinceName 	#地址 省
		_searchWarehouseDetail = _searchWarehouseDetail.set 'provinceId', warehouseLoad?.provinceId		#省 ID
		_searchWarehouseDetail = _searchWarehouseDetail.set 'cityName', warehouseLoad?.cityName 		#地址 市
		_searchWarehouseDetail = _searchWarehouseDetail.set 'cityId', warehouseLoad?.cityId			#市ID
		_searchWarehouseDetail = _searchWarehouseDetail.set 'areaName', warehouseLoad?.areaName		#地址 区
		_searchWarehouseDetail = _searchWarehouseDetail.set 'areaId', warehouseLoad?.areaId			#区ID
		_searchWarehouseDetail = _searchWarehouseDetail.set 'street', warehouseLoad?.street			#地址 街道
		_searchWarehouseDetail = _searchWarehouseDetail.set 'status', warehouseLoad?.status  			# 0-空闲中  1-已发布 2-使用中
		_searchWarehouseDetail = _searchWarehouseDetail.set 'styleType', warehouseLoad?.styleType		#  驶入式、横梁式、平推式、自动立体货架式
		_searchWarehouseDetail = _searchWarehouseDetail.set 'imageUrl', warehouseLoad?.imgurl			#图片
		_searchWarehouseDetail = _searchWarehouseDetail.set 'invoice', warehouseLoad?.isinvoice			# 0-不提供发票 1-提供发票
		_searchWarehouseDetail = _searchWarehouseDetail.set 'contact', warehouseLoad?.contacts  		#联系人姓名
		_searchWarehouseDetail = _searchWarehouseDetail.set 'contactTel', warehouseLoad?.phone 	#联系人电话
		_searchWarehouseDetail = _searchWarehouseDetail.set 'latitude', warehouseLoad?.latitude		#坐标 纬度
		_searchWarehouseDetail = _searchWarehouseDetail.set 'longitude', warehouseLoad?.longitude	#坐标 经度
		_searchWarehouseDetail = _searchWarehouseDetail.set 'remark', warehouseLoad?.remark			#仓库备注
		_searchWarehouseDetail = _searchWarehouseDetail.set 'updateTime', warehouseLoad?.updateTime		#信息更新时间
		_searchWarehouseDetail = _searchWarehouseDetail.set 'certification', data?.certification		#信息更新时间
		_searchWarehouseDetail = _searchWarehouseDetail.set 'score', data?.goodScore
		_searchWarehouseDetail = _searchWarehouseDetail.set 'userName', data?.name
		_searchWarehouseDetail = _searchWarehouseDetail.set 'wishlst', data?.wishlst
		_searchWarehouseDetail = _searchWarehouseDetail.set 'userHeaderImageUrl', data?.imgurl		#仓库主头像
		console.log _searchWarehouseDetail.wishlst + 'oooooooooooooo'
		propertyArr = warehouseLoad?.warehouseProperty or []
		tempArr = []
		for prop in propertyArr
			propertyModel = new WarehousePropertyModel
			propertyModel = propertyModel.set 'type',prop.type
			propertyModel = propertyModel.set 'attribute',prop.attribute
			propertyModel = propertyModel.set 'value',prop.value
			propertyModel = propertyModel.set 'typeName',prop.typeName
			propertyModel = propertyModel.set 'attributeName',prop.attributeName
			tempArr.push propertyModel
		_searchWarehouseDetail = _searchWarehouseDetail.set 'warehouseProperty', tempArr	#仓库各种属性的数组 
		
		WarehouseStore.emitChange 'getSearchWarehouseDetailSucc'

searchWarehouse = (params)->
	Http.post Constants.api.SEARCH_WAREHOUSE,params,(data)->
		Plugin.loading.hide()
		_warehouseSearchResult = data	#搜索仓库 返回的data本身就是数组
		WarehouseStore.emitChange 'searchWarehouseSucc'
	,null

warehouseSearchGoods = (params)->
	params.priceType = 1
	params.coldStoreFlag = 1
	Http.post Constants.api.WAREHOUSE_SEARCH_GOODS,params,(data)->
		_warehouseSearchGoodsResult = data.goods
		WarehouseStore.emitChange 'warehouseSearchGoodsSucc'


postAddWarehouse = (params,fileUrl) ->
	console.log '___...___',params
	file = [{
			filed: 'file'
			path: fileUrl
			name: 'addWarehouse.jpg'    
		}]
	Http.postFile Constants.api.WAREHOUSE_ADD,params,file,(data)->
		Plugin.loading.hide()
		console.log '发布仓库',data
	,(data)->
		console.log '发布仓库 失败', data.msg

#获取地址后回显
window.showAddressFromMap = (province,city,district,streetName,streetNumber,latitude,longitude)->
	console.log province,city,district,streetName,streetNumber,latitude,longitude
	mark = {
		mark:'getAddressFromMap'
		province:province
		city:city
		district:district 
		streetName:streetName
		streetNumber:streetNumber
		latitude:latitude
		longitude:longitude
	}
	WarehouseStore.emitChange mark

# 新增仓库时添加图片 回来后显示
window.showAddWarehouseImage = (picUrl,type)->
	console.log '_____showAddWarehouseImage_______', picUrl,type
	param = {}
	param.mark = 'addWarehouseImage:done'
	param.picUrl = picUrl
	param.type = type
	WarehouseStore.emitChange param

# window.addWarehouseBtnClick = ->
# 	WarehouseStore.emitChange "saveAddAWarehouse"
	
deleteWarehouseRequest = (warehouseId)->
	user = UserStore.getUser()
	Http.post Constants.api.DELETE_WAREHOUSE, {
		userId:user.id
		warehouseId:warehouseId
	},(data)->
		Plugin.loading.hide()
		console.log '仓库删除成功'
		DB.put 'shouldWarehouseListReload',1
		Plugin.nav.pop()
	,(data)->
		Plugin.loading.hide()
		Plugin.err.show data.msg
		console.log '仓库删除失败'
	,true

window.updateContact = (contactName,contactMobile,type)->
	mark = {
		mark:'getContectForAddWarehouse'
		contactName:contactName
		contactMobile:contactMobile
		type:type 
	}
	WarehouseStore.emitChange mark


releaseWarehouse = (warehouseId)->
	user = UserStore.getUser()
	Http.post Constants.api.RELEASE_WAREHOUSE, {
		warehouseId:warehouseId
		userId:user.id
	},(data)->
		Plugin.toast.show '发布成功'
		WarehouseStore.emitChange "warehouseReleaseSucc"
	,(data)->
		Plugin.toast.err data.msg

handleFallow = (focusid,focustype,type)->
	user = UserStore.getUser()
	Http.post Constants.api.attention, {
		focusid:focusid
		userId:user.id
		focustype:focustype
		type:type
	},(data)->
		Plugin.toast.success if parseInt(type) is 1 then '关注成功' else '取消关注成功'
		WarehouseStore.emitChange "fallowOrUnFallowHandleSucc"
	,(data)->
		Plugin.toast.err data.msg

window.editWarehouse = ->
	WarehouseStore.emitChange 'editWarehouseButtonClick'

window.trySaveEditWarehouse = ()->
	WarehouseStore.emitChange 'trySaveEditWarehouse'

doSaveEditWarehouse = (remark,phone,contacts,warehouseId)->
	user = UserStore.getUser()
	Http.post Constants.api.UPDATE_WAREHOUSE, {
		remark:remark
		phone:phone
		contacts:contacts
		warehouseId:warehouseId
		userId:user.id
	},(data)->

		WarehouseStore.emitChange "saveEditWarehouseSucc"
	,(data)->
		Plugin.toast.err data.msg


WarehouseStore = assign BaseStore, {
	getWarehouseList: ()->
		_warehouseList
	getShowType :->
		_showType
	getDetail: ()->
		_warehouse
	getSearchWarehouseDetail:()->
		_searchWarehouseDetail
	getWarehouseSearchResult: ()->
		_warehouseSearchResult
	getWarehouseSearchGoodsResult: ()->
		_warehouseSearchGoodsResult

}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_WAREHOUSE then getWarehouseList(action.status,action.pageNow,action.pageSize)
		when Constants.actionType.WAREHOUSE_DETAIL then getDetail(action.warehouseId)
		when Constants.actionType.SEARCH_WAREHOUSE then searchWarehouse(action)
		when Constants.actionType.WAREHOUSE_SEARCH_GOODS then warehouseSearchGoods(action)
		when Constants.actionType.WAREHOUSE_ADD then postAddWarehouse(action.params,action.fileUrl)
		when Constants.actionType.DELETE_WAREHOUSE then deleteWarehouseRequest(action.warehouseId)
		when Constants.actionType.RELEASE_WAREHOUSE then releaseWarehouse(action.warehouseId)
		when Constants.actionType.WAREHOUSE_SEARCH_DETAIL then getSearchWarehouseDetail(action.warehouseId,action.focusid)
		when Constants.actionType.attention then handleFallow(action.focusid,action.focustype,action.type)
		when Constants.actionType.UPDATE_WAREHOUSE then doSaveEditWarehouse(action.remark,action.phone,action.contacts,action.warehouseId)

module.exports = WarehouseStore
