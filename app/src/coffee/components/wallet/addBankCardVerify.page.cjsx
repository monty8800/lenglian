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

SmsCode = require 'components/common/smsCode'

DBBankModel = DB.get 'transData'
_aBankCardModel = new BankCardModel DBBankModel

Validator = require 'util/validator'

AddBankCardVerify = React.createClass {

	mixins:[PureRenderMixin,LinkedStateMixin]

	_getVCodeForBindBankCar:->
		WalletAction.getVCodeForBindBankCar _aBankCardModel

	_verifyNext:->
		if (not Validator.smsCode @state.smsCode) or (not _aBankCardModel.txSNBinding)
			Plugin.toast.err '请输入正确的验证码'
		else
			WalletAction.bindBankCard _aBankCardModel,@state.smsCode

	getInitialState: ->
		{
			smsCode:''
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		console.log 'event change', mark
		if mark.msg is 'getVCodeForBindBankCarSucc'
			_aBankCardModel = _aBankCardModel.set 'txSNBinding', mark.txSNBinding
			console.log '____________get it ________'
		else if mark is 'bindBankCarSucc'
			Plugin.toast.success '绑定成功！'
			DB.put 'shouldBankCardsListReload',1
			Plugin.nav.popTo 3

	render : ->
		<div>
			<div className="m-releaseitem">
				<div className="g-testCode">
					<span className="icon ll-font"></span><span>{ _aBankCardModel.bankMobile }</span>
					<div className="g-dirver-btn">
						<SmsCode mobile={_aBankCardModel.bankMobile} smsFunc={@_getVCodeForBindBankCar} type=1 />
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
