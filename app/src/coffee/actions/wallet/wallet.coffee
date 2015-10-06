'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

WalletAction = {

	getBankCardsList: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_BANK_LIST
		}
	getBankCardInfo: (cardNo)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_BANK_CARD_INFO
			cardNo:cardNo
		}
}

module.exports = WalletAction