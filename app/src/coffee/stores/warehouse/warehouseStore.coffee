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
		WarehouseStore.emitChange()

getDetail = (warehouseId) ->
	Http.post Constants.api.WAREHOUSE_DETAIL,{
		userId:_user.id
		warehouseId:warehouseId
	},(data)->
		_warehouseDetail = data.warehouseLoad
		WarehouseStore.emitChange()

WarehouseStore = assign BaseStore, {
	getWarehouseList: (status,pageNow,pageSize)->
		_warehouseList
	getShowType :->
		_showType
	getDetail: (warehouseId)->
		_warehouseDetail
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_WAREHOUSE then getWarehouseList(action.status,action.pageNow,action.pageSize)
		when Constants.actionType.WAREHOUSE_DETAIL then getDetail(action.warehouseId)



module.exports = WarehouseStore
