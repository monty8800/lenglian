React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

SetInervalMixin = require 'components/common/setIntervalMixin'


UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'



_busy = false
SmsCode = React.createClass {
	_sendSmsCode: ->
		if not Validator.mobile @props.mobile
			Plugin.alert '请输入正确的手机号码'
			return
		return null if _busy is true
		if @props.smsFunc
			@props.smsFunc()
		else
			UserAction.smsCode @props.mobile, @props.type
		_busy = true
		setTimeout ->
			_busy = false if _busy is true
		, 15000
	_countDown: ->
		time = @state.time
		if time > 0
			time--
		else
			@clearInterval()
		console.log 'time', time
		@setState {
			time: time
		}
	mixins: [PureRenderMixin, SetInervalMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change
		@clearInterval()

	_change: (msg)->
		console.log 'event change ', msg
		if msg in ["sms:done", 'getVCodeForBindBankCarSucc']
			_busy = false
			#开始倒计时
			@setState {
				time: Constants.smsGapTime
			}
			@setInterval @_countDown, 1000
		else if msg is 'register:done'
			@clearInterval()


	getInitialState: ->
		{
			time: 0
		}
	render: ->
		if @props.styleType is 'pay'
			if @state.time is 0
				return <span onClick={@_sendSmsCode}>获取验证码</span>
			else
				return <span className="u-btn-yz" disabled="disabled">{"重新获取验证码(#{@state.time})"}</span>
		else
			if @state.time is 0
				return <button className="u-btn-yz" onClick={@_sendSmsCode}>获取验证码</button>
			else
				return <button className="u-btn-yz" disabled="disabled">{"重新获取验证码(#{@state.time})"}</button>
}


module.exports = SmsCode


