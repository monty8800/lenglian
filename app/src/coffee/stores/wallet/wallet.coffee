'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
User = require 'model/user'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
BidModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'

WalletModel = require 'model/wallet'
BankCardModel = require 'model/bankCard'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'


_bankCardsList = []

_billListResult = []

_chargeRecordList = []
_presentRecordList = []

_aBankCardInfo = new BankCardModel

localBankList = DB.get 'supportBankList'
_supportBankList = Immutable.List localBankList?.list

_lastBankCard = new BankCardModel DB.get('lastBankCard')


window.tryReloadBandCardsList = ->
	shouldReload = parseInt (DB.get 'shouldBankCardsListReload')
	console.log '---------------tryReloadBandCardsList:', shouldReload
	if shouldReload is 1
		getBankCardsList()

# 充值绑定银行卡
window.refreshBankList = ->
	console.log '----------refreshBankList-'
	params = DB.get 'isRefresh'
	console.log '----------refreshBankList----', params
	if params.flag is true
		WalletAction.getBankCardsList(2)


window.updateStore = ->
	_lastBankCard = new BankCardModel DB.get('lastBankCard')
	WalletStore.emitChange 'last:bankcard:update'

getBankCardsList = (flag)->
	# 1 直接请求的  2 添加银行卡回来请求的
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
			aBankCardModel = aBankCardModel.set 'userIdNumber', obj.userIdNumber
			aBankCardModel = aBankCardModel.set 'id', obj.id
			_bankCardsList.push aBankCardModel

		# WalletStore.emitChange "getBankCardsListSucc"
		WalletStore.emitChange ["getBankCardsListSucc", flag]
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
		DB.put 'isRefresh', {
			flag: true
			cardNo: aBankCardModel.cardNo
		}
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
		_billListResult = []
		for bid in data.myPayIncomeOrOut
			do (bid) ->
				bidModel = new BidModel
				bidModel = bidModel.set 'amount', bid.amount
				bidModel = bidModel.set 'createTime', bid.createTime
				bidModel = bidModel.set 'orderNo', bid.orderNo
				bidModel = bidModel.set 'type', bid.type
				bidModel = bidModel.set 'userMobile', bid.userMobile
				_billListResult.push bidModel
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

withdraw = (params)->
	console.log 'withdraw'
	Http.post Constants.api.WITHDRAW, params, (data)->
		console.log 'withdraw result', data
		WalletStore.emitChange 'withdraw:done'
	, null
	, true

selectWithdrawCard = (card)->
	_lastBankCard = card
	DB.put 'lastBankCard', _lastBankCard
	WalletStore.emitChange 'select:withdraw:card'

# 充值
charge = (params)->
	Plugin.loading.show '正在充值...'
	console.log '-------------params:', params
	Http.post Constants.api.charge_bank, params, (data)->
		console.log '-----------result:', data
		Plugin.loading.hide()
		Plugin.nav.push ['chargeSuccess']
		DB.put 'money', params.amount
		Plugin.toast.success '充值成功'
	, (data)->
		if data.code is '0006'
			Plugin.nav.pop()
		Plugin.loading.hide()
		Plugin.toast.err data.msg

# 充值记录
chargeRecord = ->
	console.log '---------chargeRecord'
	Http.post Constants.api.charge_record, {
		userId: UserStore.getUser().id
		pageNow: 1
		pageSize: 100
	}, (data)->
		_chargeRecordList = []
		for charge in data.rechargeRecord
			wallet = new BidModel
			wallet = wallet.set 'amount', charge.amount
			wallet = wallet.set 'createTime', charge.createTime
			wallet = wallet.set 'state', charge.state
			_chargeRecordList.push wallet
		WalletStore.emitChange ['charge_record']

presentRecord = ->
	console.log '---------presentRecord'	
	Http.post Constants.api.present_record, {
		userId: UserStore.getUser().id
		pageNow: 1
		pageSize: 100
	}, (data) ->
		_chargeRecordList = []
		for charge in data.presentRecord
			wallet = new BidModel
			wallet = wallet.set 'amount', charge.amount
			wallet = wallet.set 'createTime', charge.createTime
			wallet = wallet.set 'state', charge.state
			_chargeRecordList.push wallet
		WalletStore.emitChange ['present_record']

WalletStore = assign BaseStore, {
	getBankCardsList: ->
		_bankCardsList
	getBankCardInfo: ->
		_aBankCardInfo
	getBillList:->
		_billListResult
	getSupportBankList: ->
		_supportBankList
	getLastBankCard: ->
		_lastBankCard
	getRecordList: ->
		_chargeRecordList

}


Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_BANK_LIST then getBankCardsList(action.params)
		when Constants.actionType.GET_BANK_CARD_INFO then getBankCardInfo(action.cardNo)
		when Constants.actionType.VERITY_PHONE_FOR_BANK then getVCodeForBindBankCar(action.bankCardModel)
		when Constants.actionType.ADD_BANK_CARD_PRIVET then bindBankCard(action.bankCardModel,action.smsCode)
		when Constants.actionType.GET_WALLET_IN_OUT then getBillList(action.type)
		when Constants.actionType.GET_SUPPORT_BANK_LIST then getSupportBankList()
		when Constants.actionType.WITHDRAW then withdraw(action.params)
		when Constants.actionType.SELECT_WITHDRAW_CARD then selectWithdrawCard(action.card)
		when Constants.actionType.CHARGE then charge(action.params)
		when Constants.actionType.CHARGE_RECORD then chargeRecord()
		when Constants.actionType.PRESENT_RECORD then presentRecord()

module.exports = WalletStore

