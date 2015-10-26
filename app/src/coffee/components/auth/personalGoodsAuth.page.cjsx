require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'

PicCell = require 'components/auth/PicCell'

Validator = require 'util/validator'

UserAction = require 'actions/user/user'

Constants = require 'constants/constants'


Auth = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change
		DB.remove 'transData'

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'setAuthPic:done'
			@setState {
				user: UserStore.getUser()
				name: @state.name
				idNum: @state.idNum
				mobile: @state.mobile
			}
		else if msg is 'auth:done'
			UserAction.updateUser {
				name: @state.name
				goodsStatus: 2
				certification: 1
				idCardNo: @state.idNum
				mobile: @state.mobile
			}

	_auth: ->
		if not Validator.name @state.name
			Plugin.toast.err '请输入正确的姓名'
		else if not Validator.idCard @state.idNum
			Plugin.toast.err '请输入正确的身份证号码'
		else if not @state.mobile
			Plugin.toast.err '请填写电话号码'
		else if not @state.user.idCard
			Plugin.toast.err '请上传身份证照片'
		else
			UserAction.personalAuth {
				phone: @state.mobile
				type: Constants.authType.GOODS
				username: @state.name
				userId: @state.user.id
				cardno: @state.idNum
			}, [
				{
					filed: 'idcardImg'
					path: @state.user.idCard
				}
			]

	getInitialState: ->
		user = UserStore.getUser()
		{
			user: user
			name: user.name or ''
			idNum: user.idCardNo or ''
			mobile: user.mobile or ''
		}
	render: ->
		cells = [
			{
				name: '身份证照片'
				url: @state.user.idCard
				optional: false
				type: 'idCard'
			}
		].map (cell, i)->
			<PicCell selectable={@state.user.goodsStatus is 0} key={i} type={cell.type} url={cell.url} name={cell.name} optional={cell.optional} />
		, this

		<section>
		<div className="m-cert-cons">
			<ul>
				<li>
					<h6 className="xert-h6">真实姓名</h6>
						{
							if @state.user.name and @state.user.certification isnt 0
								<input  value=@state.user.name readOnly="readonly" className="input-weak" type="text" placeholder="请输入真实姓名"/>
							else
								<input  valueLink={@linkState 'name'} className="input-weak" type="text" placeholder="请输入真实姓名"/>
						}
				</li>
				<li>
					<h6 className="xert-h6">身份证号</h6>
						{
							if @state.user.idCardNo and @state.user.certification isnt 0
								<input readOnly="readonly" value=@state.user.idCardNo className="input-weak" type="text" placeholder="请输入身份证号"/>
							else
								<input valueLink={@linkState 'idNum'} className="input-weak" type="text" placeholder="请输入身份证号"/>
						}
				</li>
				<li>
					<h6 className="xert-h6">手机号码</h6>
						{
							if @state.user.mobile
								<input readOnly="readOnly" value=@state.user.mobile className="input-weak"   maxlength="11" type="tel"/>
							else
								<input valueLink={@linkState 'mobile'} className="input-weak"   maxlength="11" type="tel"/>
						}
				</li>
			</ul>
		</div>
		<div className="m-file-upload">
			{cells}
		</div>
		{
			if @state.user.goodsStatus in [0, 3]
				<div className="u-certBtn-con">
					<a onClick={@_auth} className="u-btn">提交认证</a>
				</div>
		}

		</section>
}

React.render <Auth />, document.getElementById('content')