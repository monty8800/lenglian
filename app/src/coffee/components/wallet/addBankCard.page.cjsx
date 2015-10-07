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


AddBankCard = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	_addNewBankNext:->
		WalletAction.getBankCardInfo @state.bankCardNo

	getInitialState:->
		{
			bankCardOnwerName:''
			bankCardNo:''
		}
	componentDidMount: ->
		WalletStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		if mark is 'getBankCardInfoSucc'
			aBankModel = WalletStore.getBankCardInfo()
			aBankModel = aBankModel.set 'onwerName',@state.bankCardOnwerName
			DB.put 'transData',aBankModel
			Plugin.nav.push ['addBankCardNext']

	render : ->
		<div>
			<div className="g-bankCard">
				请绑定持卡人本人的银行卡
			</div>
			<div className="m-releaseitem">
				<div>
					<label htmlFor="packType"><span>持卡人:</span></label>
					<input valueLink={@linkState 'bankCardOnwerName'} type="text" placeholder="请输入持卡人姓名" id="packType"/>
				</div>
				<div className="u-personIcon u-close ll-font">
					<label htmlFor="packType"><span>卡&nbsp;&nbsp;&nbsp;号:</span></label>
					<input valueLink={@linkState 'bankCardNo'} type="text" placeholder="请输入银行卡号" id="packType"/>
				</div>
			</div>
			
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a onClick={ @_addNewBankNext } href="#" className="btn">下一步</a>
				</div>
			</div>
			<div className="u-green ll-font">
				同意
				<a href="#">《马甲协议》</a>
			</div>
		</div>
}
React.render <AddBankCard />,document.getElementById('content')

