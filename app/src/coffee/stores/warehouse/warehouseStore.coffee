'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
User = require 'model/user'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
Warehouse = require 'model/warehouseModel'
Immutable = require 'immutable'
DB = require 'util/storage'

_warehouse = new Warehouse

_warehouseList = Immutable.List()
_warehouseDetail = {}

# 搜索仓库结果
_warehouseSearchResult = []

# 仓库找货 搜索结果
_warehouseSearchGoodsResult = []

localUser = DB.get 'user'
_user = new User localUser
_showType = '1'

getWarehouseList = (status,pageNow,pageSize)->
	_showType = status
	console.log '获取仓库列表 status='+status+' pageNow='+pageNow+' pageSize='+pageSize + '__showType='+_showType
	Http.post Constants.api.GET_WAREHOUSE,{
		userId:_user.id
		status:status
		pageNow:pageNow
		pageSize:pageSize
	},(data)->
		_warehouseList = data.myWarehouse
		WarehouseStore.emitChange 'getMyWarehouseList'

getDetail = (warehouseId) ->
	Http.post Constants.api.WAREHOUSE_DETAIL,{
		userId:_user.id
		warehouseId:warehouseId
	},(data)->
		_warehouseDetail = data.warehouseLoad
		WarehouseStore.emitChange 'getDetailWithId'

searchWarehouse = (startNo,pageSize)->
	console.log '搜索获取仓库  startNo='+startNo+' pageSize='+pageSize
	Http.post Constants.api.SEARCH_WAREHOUSE,{
		startNo:startNo
		pageSize:pageSize
	},(data)->
		_warehouseSearchResult = data	#搜索仓库 返回的data本身就是数组
		WarehouseStore.emitChange 'searchWarehouse'

warehouseSearchGoods = (startNo,pageSize)->
	Http.post Constants.api.WAREHOUSE_SEARCH_GOODS,{
		startNo:startNo
		pageSize:pageSize
	},(data)->
		_warehouseSearchGoodsResult = data.goods
		WarehouseStore.emitChange 'warehouseSearchGoods'

WarehouseStore = assign BaseStore, {
	getWarehouseList: ()->
		_warehouseList
	getShowType :->
		_showType
	getDetail: ()->
		_warehouseDetail
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
