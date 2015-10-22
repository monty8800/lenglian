require 'components/common/common'

React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

DB = require 'util/storage'
Plugin = require 'util/plugin'
BankCardList = require 'components/order/bankCardList'

PayStore = require 'stores/order/pay'
PayAction = require 'actions/order/pay'
UserStore = require 'stores/user/user'

PaySmsCode = require 'components/order/paySmsCode'

Validator = require 'util/validator'

transData = DB.get 'transDataPay'

OrderPay = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		{
			info: null
			payPasswd: ''
			showSms: false
			payMode: 1
			bankCard: null
			user: UserStore.getUser()
			agree: true
			smsCode: null
		}

	componentDidMount: ->
		PayStore.addChangeListener @_callCB
		PayAction.getPayInfo {
			userId: UserStore.getUser()?.id
			orderNo: transData?.orderNo
		}

	componentWillNotMount: ->
		PayStore.removeChangeListener @_callCB

	_showPaySms: ->
		if @state.payMode is 1
			@_doPay()
		else
			@setState {
				showSms: true
			}

	_doPay: (smsCode)->
		if not Validator.payPasswd @state.payPasswd
			Plugin.toast.err '请输入正确的支付密码'
		else if @state.payMode isnt 1 and not Validator.smsCode @state.smsCode
			Plugin.toast.err '请输入正确的手机验证码'
		else
			PayAction.doPay {
				userId: @state.user.id
				orderNo: transData?.orderNo
				consumeOrderNo: @state.info.get 'consumeOrderNo'
				payMode: @state.payMode
				userBankCardId: @state.bankCard if @state.payMode isnt 1
				smsCode: smsCode if @state.payMode isnt 1
				payPwd: @state.payPasswd
			}

	_setPayMode: (mode)->
		@setState {
			payMode: mode
			bankCard: null
		}

	_setPayPwd: ->
		DB.put 'transData', {
			type: 'payPwd'
		}
		Plugin.nav.push ['resetPasswd']

	_callCB: (params)->
		console.log 'event----', params
		if params.msg is 'pay:info'
			@setState {
				info: params.data
			}
		else if params is 'hide:pay:sms'
			@setState {
				showSms: false
			}
		else if params.msg is 'do:pay'
			payFunc = ->
				@_doPay params.smsCode
			payFunc = payFunc.bind this
			setTimeout payFunc ,200

			@setState {
				showSms: false
			}
		else if params is 'user:update'
			@setState {
				user: UserStore.getUser()
			}
		else if params is 'pay:success'
			DB.put 'transData2', {
				orderNo: transData?.orderNo
				payAmount: @state.info?.get 'orderAmount'
			}
			Plugin.nav.push ['paySuccess']
		else if params is 'pay:done'
			DB.put 'transData2', {
				orderNo: transData?.orderNo
				payAmount: @state.info?.get 'orderAmount'
			}
			Plugin.nav.push ['paySuccess']
		else if params.msg is 'select:card'
			@setState {
				bankCard: params.cardId
				payMode: 2
			}

	render : ->
		console.log 'state---', @state
		user = @state.user
		<section>
		<div className="m-pay-item">
			<p className="g-pay clearfix">
				<span className="fl">支付金额</span>
				<span className="fr g-pay-money"><span>&yen;</span>{@state.info?.get 'orderAmount'}</span>
			</p>
			<p className="g-pay clearfix">
				<span className="fl g-payPass">输入支付密码</span>
				<span className="fr">
					{
						if user.hasPayPwd is 0
							<input onClick={@_setPayPwd} className="setPas" type="password" readOnly="readonly" placeholder="去设置支付密码"/>
						else
							<input valueLink={@linkState 'payPasswd'} className="setPas" type="password"  placeholder="请输入支付密码"/>
					}
				</span>	
			</p>
		</div>

		<div className="m-pay-item">
			<p onClick={@_setPayMode.bind this, 1} className={"g-pay offMoney ll-font" + if @state.payMode is 1 then ' active' else ''}>
				<span className="font30">余额支付</span>
				<span className="font24">{@state.info?.get('accountAmount') + '元'}</span>
			</p>
		</div>
		{
			if user.certification is 1
				<BankCardList selected={@state.bankCard} bankCardList={@state.info?.get 'bankCardList'} />
		}


		<div className="u-pay-btn">
			<div className="u-pay-btn">
				<a onClick={@_showPaySms} className="btn">立即支付</a>
			</div>
		</div>
		
		{
			if @state.showSms
				<PaySmsCode />
		}	
		</section>
}

React.render <OrderPay />,document.getElementById('content')