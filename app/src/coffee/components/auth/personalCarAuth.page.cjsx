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
				carNum: @state.carNum
				vinNum: @state.vinNum
				name: @state.name
				idNum: @state.idNum
			}
		else if msg is 'auth:done'
			UserAction.updateUser {
				name: @state.name
				carStatus: 2
				idCardNo: @state.idNum
				carNo: @state.carNum
				vinNum: @state.vinNum
			}

	_auth: ->
		if not Validator.carNum @state.carNum
			Plugin.toast.err '请输入正确的车牌号'
		else if not Validator.vinNum @state.vinNum
			Plugin.toast.err '请输入正确的车架号码'
		else if not Validator.name @state.name
			Plugin.toast.err '请输入正确的姓名'
		else if not Validator.idCard @state.idNum
			Plugin.toast.err '请输入正确的身份证号码'
		else if not @state.user.license
			Plugin.toast.err '请上传行驶证照片'
		else if not @state.user.idCard
			Plugin.toast.err '请上传身份证照片'
		else
			UserAction.personalAuth {
				phone: @state.user.mobile
				type: Constants.authType.CAR
				username: @state.name
				userId: @state.user.id
				cardno: @state.idNum
				carno: @state.carNum
				frameno: @state.vinNum
			}, [
				{
					filed: 'idcardImg'
					path: @state.user.idCard
				}
				{
					filed: 'drivingImg'
					path: @state.user.license
				}
				{
					filed: 'taxiLicenseImg'
					path: @state.user.operationLicense
				}
			]

	getInitialState: ->
		user = UserStore.getUser()
		{
			user: user
			carNum: user.carNo or ''
			vinNum: user.vinNo or ''
			name: user.name or ''
			idNum: user.idCardNo or ''
		}
	render: ->
		cells = [
			{
				name: '行驶证照片'
				url: @state.user.license
				optional: false
				type: 'license'
			}
			{
				name: '身份证照片'
				url: @state.user.idCard
				optional: false
				type: 'idCard'
			}
			{
				name: '运营证照片'
				url: @state.user.operationLicense
				optional: true
				type: 'operationLicense'
			}
		].map (cell, i)->
			<PicCell key={i} type={cell.type} url={cell.url} name={cell.name} optional={cell.optional} />
		, this

		<section>
		<div className="m-cert-cons">
			<ul>
				<li>
					<h6 className="xert-h6">车牌号码</h6>
					<input valueLink={@linkState 'carNum'} className="input-weak" type="text" placeholder="请输入车牌号码" />
				</li>
				<li>
					<h6 className="xert-h6">车架号码</h6>
					<input valueLink={@linkState 'vinNum'} className="input-weak" type="text" placeholder="请输入车架号码" />
				</li>
				<li>
					<h6 className="xert-h6">车主姓名</h6>
						{
							if @state.user.name and @state.user.certification isnt 0
								<input value=@state.user.name readOnly="readOnly" className="input-weak" type="text" placeholder="请输入车主姓名" />
							else
								<input valueLink={@linkState 'name'} className="input-weak" type="text" placeholder="请输入车主姓名" />
						}
					
				</li>
				<li>
					<h6 className="xert-h6 xert-h6-large01">车主身份证号码</h6>
						{
							if @state.user.idCardNo and @state.user.certification isnt 0
								<input value=@state.user.idCardNo readOnly="readOnly" className="input-weak" type="text" placeholder="请输入车主姓名" />
							else
								<input valueLink={@linkState 'idNum'} className="input-weak" type="text" placeholder="请输入车主姓名" />
						}
					
				</li>
			</ul>
		</div>
		<div className="m-file-upload m-file-many">
			{cells}
		</div>
		<div className="u-certBtn-con">
			<a className="u-btn" onClick={@_auth}>提交认证</a>
		</div>
		</section>
}

React.render <Auth />, document.getElementById('content')