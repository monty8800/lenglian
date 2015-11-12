React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

PayAction = require 'actions/order/pay'

SmsCode = require 'components/common/smsCode'

UserStore = require 'stores/user/user'

Validator = require 'util/validator'
Plugin = require 'util/plugin'
Constants = require 'constants/constants'

PaySmsCode = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		{
			smsCode: ''
		}
	_cancel: ->
		PayAction.hidePaySms()

	_confirm: ->
		if not Validator.smsCode @state.smsCode
			Plugin.toast.err '请输入正确的验证码!'
		else
			PayAction.payNoti @state.smsCode

	render: ->
		user = UserStore.getUser()
		<section>
		<div className="m-gray"></div>
		<div className="m-payalert">
			<div className="g-paycode">
				<p>交易需要短信确认，认证码将发送至手机：<span>{@props.mobile[0..2]}<span>****</span>{@props.mobile[-4..]}</span></p>
				<div className="g-payinput">
					<input valueLink={@linkState 'smsCode'} type="number" className="g-codeinput fl"/>
					<a className="g-paytime fr">
						<SmsCode mobile={@props.mobile} bankCard={@props.bankCard} styleType='pay' type={Constants.smsType.payOrder} />
					</a>
				</div>
			</div>
			<ul className="g-paybtn">
				<li>
					<a onClick={@_confirm} className="f-pay-confirm">确认</a>					
				</li>
				<li>
					<a onClick={@_cancel} className="f-pay-cancel">取消</a>					
				</li>
			</ul>			
		</div>
		</section>
}

module.exports = PaySmsCode