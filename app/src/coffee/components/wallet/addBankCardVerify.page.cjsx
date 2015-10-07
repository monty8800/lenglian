require 'components/common/common'
require 'user-center-style'
require 'majia-style'

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
_aBankCardModel = new BankCardModel DBBankModel

AddBankCardVerify = React.createClass {

	mixins:[PureRenderMixin,LinkedStateMixin]

	_getVCodeForBindBankCar:->
		WalletAction.getVCodeForBindBankCar _aBankCardModel

	_verifyNext:->
		WalletAction.bindBankCard _aBankCardModel,@state.smsCode
		Plugin.toast.show 'VerifyNext'

	getInitialState: ->
		{
			smsCode:''
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		if mark is 'getVCodeForBindBankCarSucc'
			console.log '____________get it ________'
		

	render : ->
		<div>
			<div className="m-releaseitem">
				<div className="g-testCode">
					<span className="icon ll-font"></span><span>{ _aBankCardModel.bankMobile }</span>
					<div className="g-dirver-btn">
						<a onClick={@_getVCodeForBindBankCar} href="#" className="u-btn02">发送验证码</a>
					</div>
				</div>
				<div className="g-testCode">
					<span> </span>
					<span><input valueLink={@linkState 'smsCode'} type="text" placeholder="请输入手机验证码"/></span>
				</div>
			</div>		
			<div className="u-pay-btn">
				<a onClick={ @_verifyNext } href="#" className="btn">下一步</a>
			</div>
		</div>
}
React.render <AddBankCardVerify />,document.getElementById('content')
