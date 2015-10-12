'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

WarehouseAction = {

	getWarehouseList: (status,pageNow,pageSize)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_WAREHOUSE
			status:status
			pageSize:pageSize
			pageNow:pageNow
		}
	getDetail:(warehouseId) ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.WAREHOUSE_DETAIL
			warehouseId: warehouseId
		}
	getSearchWarehouseDetail:(warehouseId,focusid) ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.WAREHOUSE_SEARCH_DETAIL
			warehouseId: warehouseId
			focusid:focusid
		}

	searchWarehouse:(params) ->
		params.actionType = Constants.actionType.SEARCH_WAREHOUSE
		Dispatcher.dispatch params 

	warehouseSearchGoods:(params)->
		params.actionType = Constants.actionType.WAREHOUSE_SEARCH_GOODS
		Dispatcher.dispatch params
		
	postAddWarehouse:(params,url)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.WAREHOUSE_ADD
			params:params
			fileUrl:url
		}
	deleteWarehouse:(warehouseId)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.DELETE_WAREHOUSE
			warehouseId:warehouseId
		}
	releaseWarehouse:(warehouseId)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.RELEASE_WAREHOUSE
			warehouseId:warehouseId
		}

	handleFallow:(focusid,focustype,type)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.attention
			focusid:focusid
			focustype:focustype
			type:type
		}

	doSaveEditWarehouse:(remark,phone,contacts,warehouseId)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.UPDATE_WAREHOUSE
			remark:remark
			phone:phone
			contacts:contacts
			warehouseId:warehouseId
		}
}

module.exports = WarehouseAction