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
	searchWarehouse:(startNo,pageSize) ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SEARCH_WAREHOUSE
			startNo:startNo
			pageSize:pageSize
		}
	warehouseSearchGoods:(startNo,pageSize)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.WAREHOUSE_SEARCH_GOODS
			startNo:startNo
			pageSize:pageSize
		}

}

module.exports = WarehouseAction