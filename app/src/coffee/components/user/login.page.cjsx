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



Login = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change

	_change: (msg)->
		console.log 'event change ', msg
		Plugin.nav.pop() if msg is 'login:done'

	_goPage: (page)->
		Plugin.nav.push [page]

	_login: ->
		if not Validator.mobile @state.mobile
			Plugin.alert '请输入正确的手机号码'
			return
		else if not Validator.passwd @state.passwd
			Plugin.alert '密码格式不正确'
			return
		else
			UserAction.login @state.mobile, @state.passwd
		
	getInitialState: ->
		{
			mobile: ''
			passwd: ''
		}
	render: ->
		<section>
		<div className="m-login-item">
			<ul>
				<li>
					<span className="ll-font u-user-icon"></span>
					<input type="tel" maxLength=11 placeholder="请输入手机号" valueLink={@linkState 'mobile'} />
				</li>
				<li>
					<span className="ll-font u-pass-icon"></span>
					<input type="password" placeholder="请输入密码" valueLink={@linkState 'passwd'} />
				</li>
			</ul>
		</div>
		<div className="m-login-tips clearfix">
			<a onClick={@_goPage.bind this, 'register'}>注册</a><a href="#">忘记密码?</a>
		</div>
		<div className="m-btn-con">
			<a  className="u-btn" onClick={@_login}>登录</a>
		</div>
		</section>
}


React.render <Login />, document.getElementById('content')


