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
	getVCodeForBindBankCar: (bankCardModel)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.VERITY_PHONE_FOR_BANK
			bankCardModel:bankCardModel
		}
	bindBankCard:(bankCardModel,smsCode)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ADD_BANK_CARD_PRIVET
			bankCardModel:bankCardModel
			smsCode:smsCode
		}
	removeBankCard:(cardId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.REMOVE_BANK_CARD
			cardId:cardId
		}
}

module.exports = WalletAction