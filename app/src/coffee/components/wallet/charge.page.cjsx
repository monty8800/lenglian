require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
WalletStore = require 'stores/wallet/wallet'
WalletModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Validator = require 'util/validator'
Auth = require 'util/auth'

DB = require 'util/storage'
Plugin = require 'util/plugin'
bankList = []

DB.remove 'bindCardType'
user = UserStore.getUser()

Charge = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	_sureToCharge: ->
		if @state.money.length == 0
			return Plugin.toast.err '请输入充值金额'
		if not Validator.price @state.money
			return Plugin.toast.err '请输入正确的金额, 最多两位小数, 最大9999999.99'
		if @state.payPassword.length == 0
			return Plugin.toast.err '请输入支付密码'
		if @state.cardId.length == 0
			return Plugin.toast.err '请选择银行卡'
		WalletAction.charge {
				userId: user?.id
				cardId: @state.cardId
				amount: @state.money
				payPassword: @state.payPassword
			}


	_addNewBankCard:->
		if user.carStatus is 1 or user.goodsStatus is 1 or user.warehouseStatus is 1
			DB.put 'bindCardType', '1'
			Plugin.nav.push ['addBankCard']
		else
			Auth.needAuth 'any','您尚未进行任何角色的认证，请认证后再绑定银行卡'

	getInitialState:->
		{
			bankCardsList:[]
			selectIndex:0
			payPassword: ''
			money: ''
			showSms: false
			cardId: ''
		}

	_setPayPwd: ->
		DB.put 'transData', {
			type: 'payPwd'
		}
		Plugin.nav.push ['resetPasswd']

	chooseBank: (index) ->
		console.log '-------index:', index
		@setState {
			selectIndex: index
			cardId: bankList[index].id
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange
		# 1 直接请求的  2 添加银行卡回来请求的
		WalletAction.getBankCardsList {
			userId: UserStore.getUser()?.id
			status: 1
			bindType: 1
			}, 2

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		console.log '----------mark:', mark
		if mark[0] is 'getBankCardsListSucc'
			bankList = WalletStore.getBankCardsList()
			size = bankList.length
			cardId  = ""
			selectIndex = 0
			if mark[1] is 1
				cardId = bankList[0].id
				selectIndex = 0
			else
				cardId = bankList[size - 1].id
				selectIndex = size - 1
			newState = Object.create @state
			newState.cardId = cardId
			newState.bankCardsList = bankList
			newState.selectIndex = selectIndex
			@setState newState
		else if mark is 'reloadBandCardsListAction'
			WalletAction.getBankCardsList {
				userId: UserStore.getUser()?.id
				status: 1
				bindType: 1
				}, 2


	render : ->
		bankCardsList = @state.bankCardsList.map (aBankCard,index)->
			<div className="g-bankList" key={index} onClick={@chooseBank.bind this, index}>
				<p className={ if @state.selectIndex is index then "g-bank01 ll-font active" else "g-bank01 ll-font" }>
					<span>{ aBankCard.bankName }</span>
					<span className="font24">{ aBankCard.cardType }(尾号{ aBankCard.cardNo.substr -4,4 })</span>
				</p>
			</div>
		,this

		<div>
			<div className="m-pay-item">
				<p className="g-pay">
					<span>充值金额</span>
					<input className="input-weak" type="text" valueLink={@linkState 'money'} placeholder="请输入充值金额"/>
				</p>
			</div>
			<div className="m-pay-item">
				<p className="g-pay">
					<span>支付密码</span>
					<input className="input-weak" type="password" valueLink={@linkState 'payPassword'} placeholder="请输入支付密码"/>
				</p>
			</div>
			<div className="m-pay-item">
				<p className="g-pay">
					<span className="font30">当前余额</span>
					<span className="font24">{(user.balance.toFixed 2) + '元'}</span>
				</p>
			</div>
			<div className="m-bank">			
				<h6 className="g-bankTitle">
					请选择银行卡
				</h6>
				{ bankCardsList }
				<div onClick={ @_addNewBankCard } className="g-bankList">
					<p className="g-bank02">
						<span>添加银行卡</span>
					</p>
				</div>
			</div>
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a onClick={@_sureToCharge} href="###" className="btn">立即充值</a>
				</div>
			</div>	
		</div>
}


React.render <Charge />,document.getElementById('content')

