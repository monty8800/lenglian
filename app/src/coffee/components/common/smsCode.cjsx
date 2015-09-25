React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

SetInervalMixin = require 'components/common/setIntervalMixin'


UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'




SmsCode = React.createClass {
	_sendSmsCode: ->
		if not Validator.mobile @props.mobile
			Plugin.alert '请输入正确的手机号码'
			return
		UserAction.smsCode @props.mobile, @props.type
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
		if msg is "sms:done"
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
		if @state.time is 0
			return <button className="u-btn-yz" onClick={@_sendSmsCode}>获取验证码</button>
		else
			return <button className="u-btn-yz" disabled="disabled">{"重新获取验证码(#{@state.time})"}</button>
}


module.exports = SmsCode


