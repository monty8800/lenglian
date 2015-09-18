require 'components/common/common'
require 'index-style'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

SetInervalMixin = require 'components/common/setIntervalMixin'


UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'

Auth = require 'components/user/authDialog'


Register = React.createClass {
	_register: ->
		console.log 'state', @state
		if not Validator.mobile @state.mobile
			Plugin.alert '请输入正确的手机号码'
			return
		else if not Validator.smsCode @state.code
			Plugin.alert '请输入正确长度的验证码'
			return
		else if not Validator.passwd @state.passwd
			Plugin.alert '密码格式不正确'
			return
		else if @state.passwd isnt @state.rePasswd
			Plugin.alert '两次输入密码不一致'
			return
		else if not @state.agree
			Plugin.alert '请同意服务协议'
			return
		else
			UserAction.register @state.mobile, @state.code, @state.passwd
	_sendSmsCode: ->
		if not Validator.mobile @state.mobile
			Plugin.alert '请输入正确的手机号码'
			return
		UserAction.smsCode @state.mobile, Constants.smsType.register
		newState = Object.create @state
		newState.time = 60
		@setState newState
		@setInterval @_countDown, 1000
	_countDown: ->
		newState = Object.create @state
		if newState.time > 0
			newState.time--
		else
			@clearInterval()
		console.log 'time', newState.time
		@setState newState
	mixins: [PureRenderMixin, LinkedStateMixin, SetInervalMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_success

	componentWillUnmount: ->
		UserStore.removeChangeListener @_success
		@clearInterval()

	_success: ->
		console.log 'register success!'
		newState = Object.create @state
		newState.success = true
		@setState newState
	getInitialState: ->
		{
			mobile: ''
			code: ''
			passwd: ''
			rePasswd: ''
			showPwd: false
			showRePwd: false
			agree: true
			time: 0
			success: false
		}
	render: ->
		console.log 'this', this
		smsBtn = null
		if @state.time is 0
			smsBtn = <button className="u-btn-yz" onClick={@_sendSmsCode}>获取验证码</button>
		else
			smsBtn = <button className="u-btn-yz" disabled="disabled">{"重新获取验证码(#{@state.time})"}</button>

		<section>
		<div className="m-login-item m-reg-item">
			<ul>
				<li>
					<span className="ll-font u-user-icon u-reg-icon"></span>
					<input type="tel" maxLength="11" placeholder="请输入手机号" valueLink={@linkState 'mobile'} />
					{smsBtn}
				</li>
				<li>
					<input type="text" placeholder="请输入手机验证码" valueLink={@linkState 'code'} />
				</li>
			</ul>
		</div>
		<div className="m-login-item m-reg-item02">
			<ul>
				<li>
					<span className="ll-font u-user-icon u-reg-icon01"></span>
					<input type={if @state.showPwd then 'text' else 'password'} placeholder="请输入新密码" valueLink={@linkState 'passwd'} />
					<label className="u-label"> <input className="ll-font" checkedLink={@linkState 'showPwd'} type="checkbox" dangerouslySetInnerHTML={{__html: "显示密码"}} /></label>
				</li>
				<li>
					<span className="ll-font u-user-icon u-pass-icon02"></span>
					<input type={if @state.showRePwd then 'text' else 'password'} placeholder="请确认新密码"  valueLink={@linkState 'rePasswd'}/>
					<label className="u-label"><input className="ll-font" checkedLink={@linkState 'showRePwd'} type="checkbox" dangerouslySetInnerHTML={{__html: "显示密码"}} /></label>
				</li>
			</ul>
		</div>
		<div className="m-btn-con">
			<a className="u-btn" onClick={@_register}>同意协议并注册</a>
		</div>
		<div className="m-btn-reg">
			<label className="u-label"><input className="ll-font" checkedLink={@linkState 'agree'} type="checkbox" />已阅读《冷链马甲服务协议》</label>
		</div>
		{ <Auth /> if @state.success}
		</section>
}


React.render <Register  />, document.getElementById('content')


