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
		aBankCardModel = aBankCardModel.set 'bankName',data.bankName
		aBankCardModel = aBankCardModel.set 'bankType',data.bankType
		aBankCardModel = aBankCardModel.set 'cardName',data.cardName
		aBankCardModel = aBankCardModel.set 'cardType',data.cardType
		aBankCardModel = aBankCardModel.set 'cardNo',cardNo
		aBankCardModel = aBankCardModel.set 'bigPicName',data.bigPicName
		aBankCardModel = aBankCardModel.set 'smallPicName',data.smallPicName
		aBankCardModel = aBankCardModel.set 'checkNo',data.checkNo
		aBankCardModel = aBankCardModel.set 'code',data.code
		aBankCardModel = aBankCardModel.set 'mainNo',data.mainNo
		aBankCardModel = aBankCardModel.set 'zfNo',data.zfNo

		_aBankCardInfo = aBankCardModel

		WalletStore.emitChange "getBankCardInfoSucc"
	,(data)->
		Plugin.toast.err data.msg
	,true

getVCodeForBindBankCar = (aBankCardModel)->
	user = UserStore.getUser()
	Http.post Constants.api.VERITY_PHONE_FOR_BANK, {
		userId:user.id
		cardNo:aBankCardModel.cardNo
		cardName:aBankCardModel.cardName
		blankName:aBankCardModel.bankName
		cardType:aBankCardModel.cardType
		bankMobile:aBankCardModel.bankMobile
		userIdNumber:aBankCardModel.userIdNumber
		bankCode:aBankCardModel.bankCode
		zfNo:aBankCardModel.zfNo
		bankBranchName:aBankCardModel.bankBranchName
	},(data)->
		console.log data,'______ bind card vcode _______'
		WalletStore.emitChange "getVCodeForBindBankCarSucc"
	,(data)->
		Plugin.toast.err data.msg
	,true

bindBankCard = (aBankCardModel,smsCode)->
	user = UserStore.getUser()
	Http.post Constants.api.ADD_BANK_CARD_PRIVET, {
		id:'7201beba475b49fd8b872e2d1493844a'						# 不知道是什么ID
		userId:user.id
		cardName:aBankCardModel.cardName
		cardNo:aBankCardModel.cardNo
		blankName:aBankCardModel.bankName
		cardType:aBankCardModel.cardType
		bankMobile:aBankCardModel.bankMobile
		userIdNumber:aBankCardModel.userIdNumber
		mobileCode:smsCode
		bankCode:aBankCardModel.bankCode
		zfNo:aBankCardModel.zfNo
		bankBranchName:aBankCardModel.bankBranchName
	},(data)->
		console.log data,'______ 使用验证码 绑定手机号 _______'
		WalletStore.emitChange "bindBankCarSucc"
	,(data)->
		Plugin.toast.err data.msg
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
		when Constants.actionType.VERITY_PHONE_FOR_BANK then getVCodeForBindBankCar(action.bankCardModel)
		when Constants.actionType.ADD_BANK_CARD_PRIVET then bindBankCard(action.bankCardModel,action.smsCode)


module.exports = WalletStore

