'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

AddressAction = {
	addressList: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ADDRESS_LIST
		}
	delAddress: (addressid)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.DEL_ADDRESS
			addressId: addressid
		}

	cityList: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CITY_LIST
		}

	selectAddress: (address, type, item)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SELECT_ADDRESS
			address: address
			type: type
			item: item
		}
	changeSelector: (status)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHANGE_SELECTOR
			status: status
		}
}

module.exports = AddressAction