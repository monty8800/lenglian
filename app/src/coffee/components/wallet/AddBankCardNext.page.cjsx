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

DBBankModel = DB.get 'transData'
_bankCardInfo = new BankCardModel DBBankModel

AddBankCardNext = React.createClass {
	mixins:[PureRenderMixin,LinkedStateMixin]
	_addBankCardVerify:->
		_bankCardInfo = _bankCardInfo.set 'bankBranchName',@state.bankBranchName
		_bankCardInfo = bankMobile.set 'bankBranchName',@state.bankMobile
		_bankCardInfo = userIdNumber.set 'bankBranchName',@state.userIdNumber
		DB.put 'transData',_bankCardInfo
		Plugin.nav.push ['addBankCardVerify']

	getInitialState: ->
		{
			bankName: _bankCardInfo.bankName
			cardType: _bankCardInfo.cardType
			bankBranchName:''
			bankMobile:''
			userIdNumber:''
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->

	render : ->
		<div>
			<div className="m-releaseitem">
				<div>
					<span>卡类型: </span><span>{ @state.bankName }</span><span>{ @state.cardType }</span>
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
			<div className="u-green ll-font">
				同意
				<a href="#">《马甲协议》</a>
			</div>
		</div>
}
React.render <AddBankCardNext />,document.getElementById('content')

