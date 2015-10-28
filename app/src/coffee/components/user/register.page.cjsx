require 'components/common/common'
require 'index-style'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'

Auth = require 'components/user/authDialog'
SmsCode = require 'components/common/smsCode'


Register = React.createClass {
	_register: ->
		console.log 'state', @state
		if not Validator.mobile @state.mobile
			Plugin.toast.err '请输入正确的手机号码'
			return
		else if not Validator.smsCode @state.code
			Plugin.toast.err '请输入正确长度的验证码'
			return
		else if not Validator.passwd @state.passwd
			Plugin.toast.err '密码格式不正确'
			return
		else if @state.passwd isnt @state.rePasswd
			Plugin.toast.err '两次输入密码不一致'
			return
		else if not @state.agree
			Plugin.toast.err '请同意服务协议'
			return
		else
			UserAction.register @state.mobile, @state.code, @state.passwd

	_toAgreement:->
		Plugin.nav.push ['toAgreement']

	_agreeAgreement:(e)->
		newState = Object.create @state
		newState.agree = !newState.agree
		@setState newState
		e.stopPropagation()

	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'register:done'
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
			success: false
		}
	render: ->
		console.log 'this', this
		<section>
		<div className="m-login-item m-reg-item">
			<ul>
				<li>
					<span className="ll-font u-user-icon u-reg-icon"></span>
					<input type="tel" className="input-weak" maxLength="11" placeholder="请输入手机号" valueLink={@linkState 'mobile'} />
					<SmsCode mobile={@state.mobile} type={Constants.smsType.register} />
				</li>
				<li>
					<input type="text" className="input-weak" placeholder="请输入手机验证码" valueLink={@linkState 'code'} />
				</li>
			</ul>
		</div>
		<div className="m-login-item m-reg-item02">
			<ul>
				<li>
					<span className="ll-font u-user-icon u-reg-icon01"></span>
					<input className="input-weak" type={if @state.showPwd then 'text' else 'password'} placeholder="请输入新密码" valueLink={@linkState 'passwd'} />
					<label className="u-label"> <input className="input-weak ll-font" checkedLink={@linkState 'showPwd'} type="checkbox" dangerouslySetInnerHTML={{__html: "显示密码"}} /></label>
				</li>
				<li>
					<span className="ll-font u-user-icon u-pass-icon02"></span>
					<input className="input-weak" type={if @state.showRePwd then 'text' else 'password'} placeholder="请确认新密码"  valueLink={@linkState 'rePasswd'}/>
					<label className="u-label"><input className="input-weak ll-font" checkedLink={@linkState 'showRePwd'} type="checkbox" dangerouslySetInnerHTML={{__html: "显示密码"}} /></label>
				</li>
			</ul>
		</div>
		<div className="m-btn-con">
			<a className="u-btn" onClick={@_register}>同意协议并注册</a>
		</div>
		<div className="m-btn-reg">
			<label className="u-label" onClick={@_toAgreement}><input className="ll-font" onClick={@_agreeAgreement} checked={if @state.agree then 'checked' else '' } type="checkbox" />已阅读《冷链马甲服务协议》</label>
		</div>
		{ <Auth /> if @state.success}
		</section>
}

# checkedLink={@linkState 'agree'}
React.render <Register  />, document.getElementById('content')


