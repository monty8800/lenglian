require 'components/common/common'
require 'user-center-style'


React = require 'react/addons'

#TODO: 没有获取余额
UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin


WalletAction = require 'actions/wallet/wallet'
WalletStore = require 'stores/wallet/wallet'
Validator = require 'util/validator'


Withdraw = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_onChange
		UserAction.info()

	componentWillUnmount: ->
		UserStore.removeChangeListener @_onChange

	_onChange: (msg)->
		console.log 'event change', msg
		@setState {
			user: UserStore.getUser()
			bankCard: WalletStore.getLastBankCard()
		}
		if msg is 'withdraw:done'
			DB.put 'transData', {
				amount: @state.amount
				cardType: @state.bankCard.cardType
				cardNo: @state.bankCard.cardNo
				bankName: @state.bankCard.bankName
			}
			Plugin.nav.push ['withdrawDetail']

	getInitialState: ->
		{
			user: UserStore.getUser()
			bankCard: WalletStore.getLastBankCard()
			amount: ''
			payPasswd: ''
		}
	_selectBankCard: ->
		DB.put 'transData2', {
			type: 'withdraw'
		}
		Plugin.nav.push ['withdrawBankCardList']

	_setPayPwd: ->
		DB.put 'transData', {
			type: 'payPwd'
		}
		Plugin.nav.push ['changePasswd']

	_confirm: ->
		if not @state.bankCard.cardNo
			Plugin.toast.err '请选择提现银行卡'
		else if not Validator.price @state.amount
			Plugin.toast.err '请输入正确的提现金额，最多两位小数，最大不超过9999999.99'
		else
			WalletAction.withdraw {
				userId: @state.user.id
				payPassword: @state.payPasswd
				amount: @state.amount
				withdrawBankName: @state.bankCard.bankName
				withdrawCardNo: @state.bankCard.cardNo
				withdrawCardType: @state.bankCard.cardType
				cardholder: @state.bankCard.cardName
				bankBranchName: @state.bankCard.bankBranchName
			}

	render: ->
		<section>
		<div onClick={@_selectBankCard} className="m-cashItem">
			<div className="g-cash u-arrow-right ll-font">
				<dl className="clearfix">
					{
						if @state.bankCard.cardNo
							<dd className="fl">
								<p>
									<span>{@state.bankCard.bankName}</span> <span>{@state.bankCard.cardType + ' (' + @state.bankCard.cardNo[-4..] + ')'}</span>
								</p>
								<p>24小时内到账</p>
							</dd>
						else
							<dd className="fl">
								<p>请选择提现银行卡</p>
							</dd>
					}

				</dl>
			</div>
		</div>
		<div className="m-releaseitem">
			<div>
				<label htmlFor="packType"><span>金额 (元)</span></label>
				<input type="text" valueLink={@linkState 'amount'} placeholder={'当前零钱余额' + @state.user?.balance} id="packType"/>
			</div>
		</div>
		

		<div className="m-releaseitem">
			<div>
				<label htmlFor="packType"><span>支付密码</span></label>
				{
					if @state.user?.hasPayPwd is 1
						<input type="password" valueLink={@linkState 'payPasswd'} placeholder='请输入支付密码' />
					else
						<input onClick={@_setPayPwd} type="password" readOnly="readOnly" placeholder='设置支付密码' />
				}
			</div>
		</div>

		<div onClick={@_confirm} className="u-pay-btn">
			<div className="u-pay-btn">
				<a className="btn">下一步</a>
			</div>
		</div>
		</section>
}

React.render <Withdraw  />, document.getElementById('content')