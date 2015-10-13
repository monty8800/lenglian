require 'components/common/common'

React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

DB = require 'util/storage'
BankCardList = require 'components/order/bankCardList'

PayStore = require 'stores/order/pay'
PayAction = require 'actions/order/pay'
UserStore = require 'stores/user/user'

PaySmsCode = require 'components/order/paySmsCode'

transData = DB.get 'transData'

OrderPay = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		{
			info: null
			payPasswd: ''
			showSms: false
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
		@setState {
			showSms: true
		}

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
		else if params is 'do:pay'
			@setState {
				showSms: false
			}
			#TODO: 调用支付接口，接口还没有哦

	render : ->
		user = UserStore.getUser()
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
							<input className="setPas" type="password" readOnly="readonly" placeholder="去设置支付密码"/>
						else
							<input valueLink={@linkState 'payPasswd'} className="setPas" type="password"  placeholder="请输入支付密码"/>
					}
				</span>	
			</p>
		</div>

		<div className="m-pay-item">
			<p className="g-pay offMoney ll-font">
				<span className="font30">余额支付</span>
				<span className="font24">{@state.info?.get('accountAmount') + '元'}</span>
			</p>
		</div>

		<BankCardList />


		<div className="u-pay-btn">
			<div className="u-pay-btn">
				<a onClick={@_showPaySms} className="btn">立即支付</a>
			</div>
		</div>
		
		<div className="u-green ll-font">
			同意
			<a >《马甲协议》</a>
		</div>
		{
			if @state.showSms
				<PaySmsCode />
		}	
		</section>
}

React.render <OrderPay />,document.getElementById('content')