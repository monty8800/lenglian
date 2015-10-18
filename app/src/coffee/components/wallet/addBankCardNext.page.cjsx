require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

UserStore = require 'stores/user/user'
WalletStore = require 'stores/wallet/wallet'
WalletModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'
BankCardModel = require 'model/bankCard'

DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()

Validator = require 'util/validator'

DBBankModel = DB.get 'transData'
_bankCardInfo = new BankCardModel DBBankModel

AddBankCardNext = React.createClass {
	mixins:[PureRenderMixin,LinkedStateMixin]
	_addBankCardVerify:->
		if @state.bankName is '请选择银行'
			Plugin.toast.err '请选择银行'
		else if @state.bankBranchName.length < 4
			Plugin.toast.err '请输入正确的开户行'
		else if not Validator.mobile @state.bankMobile
			Plugin.toast.err '请输入正确的手机号'
		else if not Validator.idCard @state.userIdNumber
			Plugin.toast.err '请输入正确的身份证号码'
		else
			_bankCardInfo = _bankCardInfo.set 'bankBranchName',@state.bankBranchName
			_bankCardInfo = _bankCardInfo.set 'bankMobile',@state.bankMobile
			_bankCardInfo = _bankCardInfo.set 'userIdNumber',@state.userIdNumber
			_bankCardInfo = _bankCardInfo.set 'bankName', @state.bankName
			DB.put 'transData',_bankCardInfo
			Plugin.nav.push ['addBankCardVerify']

	getInitialState: ->
		{
			bankName: _bankCardInfo.bankName or '请选择银行'
			cardType: _bankCardInfo.cardType
			bankBranchName: ''
			bankMobile:''
			userIdNumber:''
			bankList: WalletStore.getSupportBankList()
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange
		WalletAction.getSupportBankList()

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		console.log 'event ', mark
		if mark is 'get:support:bank:list:done'
			@setState {
				bankList: WalletStore.getSupportBankList()
			}

	render : ->
		console.log 'new state', @state
		<div>
			<div className="m-releaseitem">

				<div className="u-arrow-right ll-font">
					<span>卡类型</span>
					<i className="arrow-i">{@state.bankName}</i>
					<select className="select" valueLink={@linkState 'bankName'} name="">
						{
							@state.bankList.map (bk, i)->
								<option key={i} value={bk.bankName}>{bk.bankName}</option>
						}
					</select>
				</div>
				<div>
					<label htmlFor="packType"><span>开户行:</span></label>
					<input valueLink={@linkState 'bankBranchName'} type="text" placeholder="请输入开户行" id="packType"/>
				</div>
				<div>
					<label htmlFor="packType"><span>手机号:</span></label>
					<input valueLink={@linkState 'bankMobile'} type="text" placeholder="银行预留手机号码" id="packType"/>
				</div>
				<div>
					<label htmlFor="packType"><span>身份证号:</span></label>
					<input valueLink={@linkState 'userIdNumber'} type="text" placeholder="持卡人身份证号码" id="packType"/>
				</div>
			</div>
			<div className="u-pay-btn">
				<a onClick={ @_addBankCardVerify } href="#" className="btn noUse">下一步</a>
			</div>
		</div>
}
React.render <AddBankCardNext />,document.getElementById('content')

