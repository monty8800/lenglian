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
}

module.exports = AddressAction