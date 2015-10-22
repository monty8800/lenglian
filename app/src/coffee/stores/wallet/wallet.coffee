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

_billListResult = []

_aBankCardInfo = new BankCardModel

localBankList = DB.get 'supportBankList'
_supportBankList = Immutable.List localBankList?.list


window.tryReloadBandCardsList = ->
	shouldReload = parseInt (DB.get 'shouldBankCardsListReload')
	console.log '---------------tryReloadBandCardsList:', shouldReload
	if shouldReload is 1
		getBankCardsList()

getBankCardsList = ->
	user = UserStore.getUser()
	Http.post Constants.api.GET_BANK_LIST, {
		userId:user.id
	},(data)->
		_bankCardsList = []	#不用分页  所以请求到结果先清空数组
		for obj in data
			aBankCardModel = new BankCardModel
			aBankCardModel = aBankCardModel.set 'bankBranchName',obj.bankBranchName
			aBankCardModel = aBankCardModel.set 'bankName',obj.blankName
			aBankCardModel = aBankCardModel.set 'cardName',obj.cardName
			aBankCardModel = aBankCardModel.set 'cardType',obj.cardType
			aBankCardModel = aBankCardModel.set 'cardNo',obj.cardNo
			_bankCardsList.push aBankCardModel

		WalletStore.emitChange "getBankCardsListSucc"
		DB.remove 'shouldBankCardsListReload'

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
		aBankCardModel = aBankCardModel.set 'bankCode',data.code
		aBankCardModel = aBankCardModel.set 'mainNo',data.mainNo
		aBankCardModel = aBankCardModel.set 'zfNo',data.zfNo

		_aBankCardInfo = aBankCardModel

		WalletStore.emitChange "getBankCardInfoSucc"
	,(data)->
		WalletStore.emitChange "getBankCardInfoFailed"
	,true

getVCodeForBindBankCar = (aBankCardModel)->
	user = UserStore.getUser()
	Http.post Constants.api.VERITY_PHONE_FOR_BANK, {
		userId:user.id
		cardNo:aBankCardModel.cardNo
		cardName:aBankCardModel.onwerName
		blankName:aBankCardModel.bankName
		cardType:aBankCardModel.cardType
		bankMobile:aBankCardModel.bankMobile
		userIdNumber:aBankCardModel.userIdNumber
		bankCode:aBankCardModel.bankCode
		zfNo:aBankCardModel.zfNo
		bankBranchName:aBankCardModel.bankBranchName
	},(data)->
		console.log data,'______ bind card vcode _______'
		return Plugin.toast.err data.resultMsg if data.resultCode isnt '0000'
		WalletStore.emitChange {
			msg: 'getVCodeForBindBankCarSucc'
			txSNBinding: data.txSNBinding
		}
	,(data)->
		Plugin.toast.err data.msg
	,true

bindBankCard = (aBankCardModel,smsCode)->
	user = UserStore.getUser()
	api = if user.certification is 2 then Constants.api.ADD_BANK_CARD_COMMPANY else Constants.api.ADD_BANK_CARD_PRIVET
	Http.post api, {
		id: aBankCardModel.txSNBinding						# 不知道是什么ID
		userId:user.id
		cardName:aBankCardModel.onwerName
		cardNo:aBankCardModel.cardNo
		blankName:aBankCardModel.bankName
		cardType:aBankCardModel.cardType
		bankMobile:aBankCardModel.bankMobile
		userIdNumber:aBankCardModel.userIdNumber
		mobileCode:smsCode if smsCode
		bankCode:aBankCardModel.bankCode
		zfNo:aBankCardModel.zfNo
		bankBranchName:aBankCardModel.bankBranchName
	},(data)->
		console.log data,'______ 使用验证码 绑定手机号 _______'
		WalletStore.emitChange "bindBankCarSucc"
	,(data)->
		Plugin.toast.err data.msg
	,true

getBillList = (type)->
	user = UserStore.getUser()
	Http.post Constants.api.GET_WALLET_IN_OUT, {
		type:type
		userId:user.id
	},(data)->
		_billListResult = data.myPayIncomeOrOut
		if _billListResult.length < 1
			if parseInt(type) is 1
				_billListResult = [
					{
						amount:-14
						createTime: "2015-10-07 06:88:59"
						type: 1				#,//类型 1:充值 2:提现 3:付款 4：收款
						userMobile: "假数据"
					}
					{
						amount:-1084
						createTime: "2015-10-8 19:99:59"
						type: 4				#,//类型 1:充值 2:提现 3:付款 4：收款
						userMobile: "有真数据的时候不会显示"
					}
				]
			else 
				_billListResult = [
					{
						amount:-14
						createTime: "2015-10-07 06:88:59"
						type: 2				#,//类型 1:充值 2:提现 3:付款 4：收款
						userMobile: "提现"
					}
					{
						amount:-1084
						createTime: "2015-10-8 19:99:59"
						type: 3				#,//类型 1:充值 2:提现 3:付款 4：收款
						userMobile: "付款"
					}
				]
		WalletStore.emitChange "getBillListSucc"
	,(data)->
		Plugin.toast.err data.msg

getSupportBankList = ->
	console.log 'get GET_SUPPORT_BANK_LIST'
	localBankList = DB.get 'supportBankList'
	now = new Date
	if not localBankList or now.getTime() - localBankList?.updateTime  > Constants.cache.SUPPORT_BANK_LIST
		console.log 'update bank list'
		Http.post Constants.api.GET_SUPPORT_BANK_LIST, {
			userId: UserStore.getUser()?.id
		}, (data)->
			_supportBankList = Immutable.List data
			DB.put 'supportBankList', {
				updateTime: now.getTime()
				list: data
			}
			WalletStore.emitChange 'get:support:bank:list:done'
	else
		WalletStore.emitChange 'get:support:bank:list:done'

WalletStore = assign BaseStore, {
	getBankCardsList: ->
		_bankCardsList
	getBankCardInfo: ->
		_aBankCardInfo
	getBillList:->
		_billListResult
	getSupportBankList: ->
		_supportBankList

}


Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_BANK_LIST then getBankCardsList()
		when Constants.actionType.GET_BANK_CARD_INFO then getBankCardInfo(action.cardNo)
		when Constants.actionType.VERITY_PHONE_FOR_BANK then getVCodeForBindBankCar(action.bankCardModel)
		when Constants.actionType.ADD_BANK_CARD_PRIVET then bindBankCard(action.bankCardModel,action.smsCode)
		when Constants.actionType.GET_WALLET_IN_OUT then getBillList(action.type)
		when Constants.actionType.GET_SUPPORT_BANK_LIST then getSupportBankList()

module.exports = WalletStore

