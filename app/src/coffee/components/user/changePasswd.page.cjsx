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

SmsCode = require 'components/common/smsCode'
DB = require 'util/storage'

transData = DB.get 'transData'
user = UserStore.getUser()
hasPayPwd = user.hasPayPwd is 1
Plugin.run [3,'navTitleString',transData.type,user.hasPayPwd]

ResetPwd = React.createClass {
	_changePwd: ->
		console.log 'state', @state
		if not Validator.mobile @state.mobile
			Plugin.toast.err '请输入正确的手机号码'
			return
		else if (transData.type isnt 'payPwd' or hasPayPwd) and not Validator.passwd @state.oldPasswd
			Plugin.toast.err '原密码格式不正确'
			return
		else if not Validator.passwd @state.passwd
			Plugin.toast.err '新密码格式不正确'
			return
		else if @state.passwd isnt @state.rePasswd
			Plugin.toast.err '两次输入密码不一致'
			return
		else
			if transData?.type is 'payPwd'
				UserAction.setPayPwd @state.passwd, @state.oldPasswd
			else
				UserAction.changePasswd @state.oldPasswd, @state.passwd

	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change
		DB.remove 'transData'

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'changePasswd:done'
			console.log 'changePasswd success!'
			# Plugin.nav.pop()
			Plugin.nav.push ['change_login_pwd_success']
			Plugin.toast.success '密码修改成功！'
		else if msg is 'setPayPwd:done'
			if hasPayPwd
				# Plugin.nav.pop()
				console.log '-----------setPwdSuccess:', UserStore.getUser().toJS()
				Plugin.toast.success '修改支付密码成功！'
			else
				Plugin.nav.pop()
				Plugin.toast.success '设置支付密码成功！'

	getInitialState: ->
		{
			mobile: UserStore.getUser()?.mobile
			oldPasswd: ''
			passwd: ''
			rePasswd: ''
		}
	render: ->
		console.log 'hasPayPwd', hasPayPwd
		oldPasswd = <li><span className="ll-font u-user-icon c-icon01"></span><input className="input-weak" type="password" placeholder="原密码" valueLink={@linkState 'oldPasswd'} /></li>
		<section>
		<div className="m-change-div ll-font">
			{@state.mobile}
		</div>
		<div className="m-login-item m-login-change">
			<ul>
				{if transData?.type isnt 'payPwd' or hasPayPwd then oldPasswd else null}
				<li>
					<span className="ll-font u-user-icon c-icon02"></span>
					<input className="input-weak" type="password" placeholder="新密码" valueLink={@linkState 'passwd'} />
				</li>
				<li>
					<span className="ll-font u-user-icon c-icon03"></span>
					<input className="input-weak" type="password" placeholder="确认密码" valueLink={@linkState 'rePasswd'} />
				</li>
			</ul>
		</div>
		<div className="m-btn-con">
			<a onClick={@_changePwd} className="u-btn">确定</a>
		</div>
		</section>
}


React.render <ResetPwd  />, document.getElementById('content')


