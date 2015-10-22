require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
WalletStore = require 'stores/wallet/wallet'
WalletModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()
Validator = require 'util/validator'

AddBankCard = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	_addNewBankNext:->
		console.log 'state', @state
		if not Validator.name @state.bankCardOnwerName
			Plugin.toast.err '请输入正确的姓名'
		else if not Validator.bankCard @state.bankCardNo
			Plugin.toast.err '请输入正确的银行卡号'
		else if not @state.agree
			Plugin.toast.err '请同意冷链马甲服务协议'
		else
			WalletAction.getBankCardInfo @state.bankCardNo

	_goAgreement: (e)->
		e.preventDefault()
		Plugin.nav.push ['agreement']

	getInitialState:->
		{
			bankCardOnwerName:''
			bankCardNo:''
			agree: true
		}
	componentDidMount: ->
		WalletStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		console.log 'event change', mark
		if mark in ['getBankCardInfoSucc', 'getBankCardInfoFailed']
			aBankModel = WalletStore.getBankCardInfo()
			aBankModel = aBankModel.set 'onwerName', @state.bankCardOnwerName
			aBankModel = aBankModel.set 'cardNo', @state.bankCardNo

			DB.put 'transData',aBankModel.toJS()
			Plugin.nav.push ['addBankCardNext']

	render : ->
		<div>
			<div className="g-bankCard">
				请绑定持卡人本人的银行卡
			</div>
			<div className="m-releaseitem">
				<div>
					<label htmlFor="packType"><span>持卡人:</span></label>
					<input className="input-weak" valueLink={@linkState 'bankCardOnwerName'} type="text" placeholder="请输入持卡人姓名" id="packType"/>
				</div>
				<div className="u-personIcon u-close ll-font">
					<label htmlFor="packType"><span>卡&nbsp;&nbsp;&nbsp;号:</span></label>
					<input className="input-weak" valueLink={@linkState 'bankCardNo'} type="text" placeholder="请输入银行卡号" id="packType"/>
				</div>
			</div>
			
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a onClick={ @_addNewBankNext } href="#" className="btn">下一步</a>
				</div>
			</div>

			<div className="u-green" style={{paddingLeft: '0 rem'}}>
				<label className="u-label" >同意<input  className="ll-font" checkedLink={@linkState 'agree'}  type="checkbox" /><span onClick={@_goAgreement} >《冷链马甲服务协议》</span></label>
			</div>
		</div>
}
React.render <AddBankCard />,document.getElementById('content')

