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

}

module.exports = WarehouseAction