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

ResetPwd = React.createClass {
	_changePwd: ->
		console.log 'state', @state
		if not Validator.mobile @state.mobile
			Plugin.alert '请输入正确的手机号码'
			return
		else if (transData.type isnt 'payPwd' or hasPayPwd) and not Validator.passwd @state.oldPasswd
			Plugin.alert '原密码格式不正确'
			return
		else if not Validator.passwd @state.passwd
			Plugin.alert '新密码格式不正确'
			return
		else if @state.passwd isnt @state.rePasswd
			Plugin.alert '两次输入密码不一致'
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
			Plugin.alert '密码修改成功！'
			Plugin.nav.pop()
		else if msg is 'setPayPwd:done'
			if hasPayPwd
				Plugin.alert '修改支付密码成功！'
				Plugin.nav.pop()
			else
				Plugin.alert '设置支付密码成功！'
				Plugin.nav.pop()

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


