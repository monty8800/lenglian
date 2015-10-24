'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

CarAction = {

	searchCarList: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SEARCH_CAR
			params: params
		}

	info: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FOUND_CAR
			params: params
		}

	carList: (statu, pageNow)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_LIST
			status: statu
			pageNow: pageNow
		}

	carDetail: (carid)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_DETAIL
			carId: carid
		}

	addCar: (params, files)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.ADD_CAR
			params: params
			files: files
		}

	releaseCar: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.RELEASE_CAR
			params: params
		}

	getFreedomCar: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FREEDOM_CAR
		}

	checkedLenAll: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHECKED_LEN_ALL
		}

	unCheckedLenAll: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.UNCHECKED_LEN_ALL
		}
	
	checkedLen_who: (params, p2)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHECKED_LEN_ST
			params: params
			param: p2
		}

	uncheckedLen_who: (params, p2)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.UNCHECKED_LEN_ST
			params: params
			param: p2
		}
		
	closeCarLen: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CLOSE_CAR_LEN
		}

	checkedHeaAll: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHECKED_HEA_ALL
		}

	unCheckedHeaAll: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.UNCHECKED_HEA_ALL
		}

	checkedHea_who: (params, p2)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHECKED_HEA_ST
			params: params
			param: p2
		}

	uncheckedHea_who: (params, p2)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.UNCHECKED_HEA_ST
			params: params
			param: p2
		}

	hahaha: (params, p2)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.HAHAHA
			params: params
			param: p2
		}

	closeCarHea: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CLOSE_CAR_HEA
		}	

	closeCarInvoince: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CLOSE_INVOINCE
		}

	needInv: (type)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.NEEDINV
			type: type
		}
	notNeedInv: (type)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.NOTNEEDINV
			type: type
		}

	delCar: (carId, status, index)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.DEL_CAR
			carId: carId
			status: status
			index: index
		}
	modifyCar: (param)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.MODIFY_CAR
			param: param
		}
	carOwnerDetail: (carId, targetUserId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_OWNER_DETAIL
			carId: carId
			targetUserId: targetUserId
		}
	attentionDetail: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ATTENTION_DETAIL
			params: params
		}

	updateInvState: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.UPDATE_INV_STATUS
			params: params
		}	
	AddCarSelection: (params) ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ADD_CAR_SELECTION
			params: params
		}

	orderSelectCarList: (params)->	
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_SELECT_CAR_LIST
			params: params
		}

	invStChecked: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.INVST
			params: params
		}

	invStNotChecked: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.INVNOTST
			params: params
		}		

}

module.exports = CarAction
