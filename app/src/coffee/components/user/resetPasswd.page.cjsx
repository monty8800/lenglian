require 'components/common/common'
require 'index-style'


React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'
DB = require 'util/storage'

transData = DB.get 'transData'


SmsCode = require 'components/common/smsCode'


ResetPwd = React.createClass {
	_resetPwd: ->
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
		else
			if transData?.type is 'payPwd'
				UserAction.resetPayPwd @state.mobile, @state.code, @state.passwd
			else
				UserAction.resetPasswd @state.mobile, @state.code, @state.passwd

	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change
		DB.remove 'transData'

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'resetPasswd:done'
			console.log 'resetPasswd success!'
			Plugin.nav.pop()
			Plugin.toast.success '密码设置成功！'
		else if msg is 'resetPayPwd:done'
			Plugin.nav.pop()
			Plugin.toast.success '支付密码设置成功！'

	getInitialState: ->
		{
			mobile: if transData?.type is 'payPwd' then UserStore.getUser().mobile else ''
			code: ''
			passwd: ''
			rePasswd: ''
			showPwd: false
			showRePwd: false
		}
	render: ->
		console.log 'this', this
		mobile = null
		if transData?.type is 'payPwd'
			mobile = <input type="tel" maxLength="11" placeholder="请输入手机号" valueLink={@linkState 'mobile'} disabled="disabled" />
		else
			mobile = <input type="tel" maxLength="11" placeholder="请输入手机号" valueLink={@linkState 'mobile'} />
		<section>
		<div className="m-login-item m-reg-item">
			<ul>
				<li>
					<span className="ll-font u-user-icon u-reg-icon"></span>
					{mobile}
					<SmsCode mobile={@state.mobile} type={if transData?.type is 'payPwd' then Constants.smsType.resetPayPwd else Constants.smsType.resetPwd} />
				</li>
				<li>
					<input type="text" placeholder="请输入手机验证码" valueLink={@linkState 'code'} />
				</li>
			</ul>
		</div>
		<div className="m-login-item m-reg-item02">
			<ul>
				<li>
					<span className="ll-font u-user-icon u-reg-icon03"></span>
					<input type={if @state.showPwd then 'text' else 'password'} placeholder="请输入新密码" valueLink={@linkState 'passwd'} />
					<label className="u-label"> <input className="ll-font" checkedLink={@linkState 'showPwd'} type="checkbox" dangerouslySetInnerHTML={{__html: "显示密码"}} /></label>
				</li>
				<li>
					<span className="ll-font u-user-icon u-pass-icon04"></span>
					<input type={if @state.showRePwd then 'text' else 'password'} placeholder="请确认新密码"  valueLink={@linkState 'rePasswd'}/>
					<label className="u-label"><input className="ll-font" checkedLink={@linkState 'showRePwd'} type="checkbox" dangerouslySetInnerHTML={{__html: "显示密码"}} /></label>
				</li>
			</ul>
		</div>
		<div className="m-btn-con">
			<a className="u-btn" onClick={@_resetPwd}>完成</a>
		</div>

		</section>
}


React.render <ResetPwd  />, document.getElementById('content')


