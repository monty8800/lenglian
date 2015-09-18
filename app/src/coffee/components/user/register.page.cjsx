require 'components/common/common'
require 'index-style'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

SetInervalMixin = require 'components/common/setIntervalMixin'


UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'


Register = React.createClass {
	_register: ->
		console.log 'state', @state
	_sendSmsCode: ->
		newState = Object.create @state
		newState.time = 60
		@setState newState
		@setInterval @_countDown, 1000
	_countDown: ->
		newState = Object.create @state
		newState.time--
		console.log 'time', newState.time
		@setState newState
	mixins: [PureRenderMixin, LinkedStateMixin, SetInervalMixin]
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
		</section>
}


React.render <Register  />, document.getElementById('content')


