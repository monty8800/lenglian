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

WalletStore = assign BaseStore, {
	getBankCardsList: ->
		_bankCardsList
}


Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_BANK_LIST then getBankCardsList()
	
module.exports = WalletStore

