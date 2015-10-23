'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

WalletAction = {
	
	getBillList:(type)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.GET_WALLET_IN_OUT
			type:type
		}

	getBankCardsList: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_BANK_LIST
			params: params
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
	getSupportBankList: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_SUPPORT_BANK_LIST
		}
	withdraw: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.WITHDRAW
			params: params
		}
	selectWithdrawCard: (card)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SELECT_WITHDRAW_CARD
			card: card
		}
	charge: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHARGE
			params: params
		}
		
}

module.exports = WalletAction