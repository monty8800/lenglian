'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
User = require 'model/user'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

WalletModel = require 'model/wallet'
BankCardModel = require 'model/bankCard'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'


_bankCardsList = []

_aBankCardInfo = new BankCardModel

getBankCardsList = ->
	user = UserStore.getUser()
	Http.post Constants.api.GET_BANK_LIST, {
		userId:user.id
	},(data)->
		for obj in data
			aBankCardModel = new BankCardModel
			aBankCardModel = aBankCardModel.set 'bankBranchName',obj.bankBranchName
			aBankCardModel = aBankCardModel.set 'bankName',obj.blankName
			aBankCardModel = aBankCardModel.set 'cardName',obj.cardName
			aBankCardModel = aBankCardModel.set 'cardType',obj.cardType
			aBankCardModel = aBankCardModel.set 'cardNo',obj.cardNo
			_bankCardsList.push aBankCardModel

		WalletStore.emitChange "getBankCardsListSucc"
	,(date)->
		Plugin.err.show date.msg

getBankCardInfo = (cardNo)->
	user = UserStore.getUser()
	Http.post Constants.api.GET_BANK_CARD_INFO, {
		userId:user.id
		cardNo:cardNo
	},(data)->
		aBankCardModel = new BankCardModel
		aBankCardModel = aBankCardModel.set 'bankName',data.blankName
		aBankCardModel = aBankCardModel.set 'cardName',data.cardName
		aBankCardModel = aBankCardModel.set 'cardType',data.cardType
		aBankCardModel = aBankCardModel.set 'cardNo',cardNo
		aBankCardModel = aBankCardModel.set 'zfNo',data.zfNo

		# bankName": "建设银行", 
		#         "bankType": "01050000", 
		#         "bigPicName": "http://qa-pic.lenglianmajia.com/105.gif", 
		#         "cardLength": 19, 
		#         "cardName": "龙卡通", 
		#         "cardType": "借记卡", 
		#         "checkNo": "621700", 
		#         "code": "5b89d8838bfc0b35d3", 
		#         "mainNo": "621700xxxxxxxxxxxxx", 
		#         "picPath": "http://qa-pic.lenglianmajia.com/", 
		#         "smallPicName": "http://qa-pic.lenglianmajia.com/s_105.gif", 
		#         "zfNo": "105"

		_aBankCardInfo = aBankCardModel

		WalletStore.emitChange "getBankCardInfoSucc"
	,(date)->
		Plugin.err.show date.msg
	,true


WalletStore = assign BaseStore, {
	getBankCardsList: ->
		_bankCardsList
	getBankCardInfo: ->
		_aBankCardInfo
}


Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_BANK_LIST then getBankCardsList()
		when Constants.actionType.GET_BANK_CARD_INFO then getBankCardInfo(action.cardNo)



module.exports = WalletStore

