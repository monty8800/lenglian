'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

WalletAction = {

	getBankCardsList: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_BANK_LIST
		}
}

module.exports = WalletAction