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
				companyName: @state.companyName
				managerName: @state.managerName
				businessLicenseNo: @state.businessLicenseNo
				# organizingCode: @state.organizingCode
				transLicenseNo: @state.transLicenseNo
			}
		else if msg is 'auth:done'
			UserAction.updateUser {
				company: @state.companyName
				carStatus: 2
				enterpriseCarStatus: 0
				certification: 2
				name: @state.managerName
				businessLicenseNo: @state.businessLicenseNo
				# organizingCode: @state.organizingCode
				transLicenseNo: @state.transLicenseNo
			}

	_auth: ->
		if not Validator.company @state.companyName
			Plugin.toast.err '请输入正确的公司名称'
		else if not Validator.name @state.managerName
			Plugin.toast.err '请输入正确的姓名'
		else if not Validator.businessLicenseNo @state.businessLicenseNo
			Plugin.toast.err '请输入正确的营业执照'
		# else if not Validator.organizingCode @state.organizingCode
			# Plugin.toast.err '请输入正确的组织资格代码'
		else if not Validator.transLicenseNo @state.transLicenseNo
			Plugin.toast.err '请输入正确的道路运输许可证'
		else if not Validator.tel @state.tel
			Plugin.toast.err '请输入正确的固定电话'	
		else if not @state.user.businessLicense
			Plugin.toast.err '请上传营业执照照片'
		else if not @state.user.transLicensePic
			Plugin.toast.err '请上传道路运输许可证照片'
		# else if not @state.user.companyPic
		# 	Plugin.toast.err '请上传门头照片'
					
		else
			UserAction.companyAuth {
				type: Constants.authType.CAR
				name: @state.companyName
				licenseno: @state.businessLicenseNo
				# certifies: @state.organizingCode
				permits: @state.transLicenseNo
				principalName: @state.managerName
				phone: @state.tel
				userId: @state.user.id
			}, [
				{
					filed: 'businessLicenseImg'
					path: @state.user.businessLicense
				}
				{
					filed: 'transportImg'
					path: @state.user.transLicensePic
				}
				{
					filed: 'doorImg'
					path: @state.user.companyPic
				}
			]

	getInitialState: ->
		user = UserStore.getUser()
		{
			user: user
			companyName: user.company or ''
			managerName: user.name or ''
			businessLicenseNo: user.businessLicenseNo or ''
			# organizingCode: user.organizingCode or ''
			transLicenseNo: user.transLicenseNo or ''
			tel: user.tel or ''
		}
	render: ->
		cells = [
			{
				name: '营业执照'
				url: @state.user.businessLicense
				optional: false
				type: 'businessLicense'
			}
			{
				name: '道路运输许可证'
				url: @state.user.transLicensePic
				optional: false
				type: 'transLicensePic'
			}
			{
				name: '门头照片'
				url: @state.user.companyPic
				optional: true
				type: 'companyPic'
			}
		].map (cell, i)->
			<PicCell selectable={@state.user.carStatus is 0} key={i} type={cell.type} url={cell.url} name={cell.name} optional={cell.optional} />
		, this

		<section>
		<div className="m-cert-cons">
			<ul>
				<li>
					<h6 className="xert-h6 xert-h6-large03">运输公司名称</h6>
						{
							if @state.user.company and @state.user.certification isnt 0
								<input value=@state.user.company readOnly="readOnly" className="input-weak" type="text" placeholder="请输入公司名称" />
							else
								<input valueLink={@linkState 'companyName'} className="input-weak" type="text" placeholder="请输入公司名称" />
						}
					
				</li>
				<li>
					<h6 className="xert-h6 xert-h6-large03">负责人的姓名</h6>
						{
							if @state.user.name and @state.user.certification isnt 0
								<input value=@state.user.name readOnly="readOnly" className="input-weak" type="text" placeholder="请输入负责人姓名" />
							else
								<input valueLink={@linkState 'managerName'} className="input-weak" type="text" placeholder="请输入负责人姓名" />
						}
				</li>
				<li>
					<h6 className="xert-h6 xert-h6-large03">营业执照号码</h6>
						{
							if @state.user.businessLicenseNo and @state.user.certification isnt 0
								<input value=@state.businessLicenseNo readOnly="readOnly" className="input-weak" type="text" placeholder="营业执照号码" />
							else
								<input valueLink={@linkState 'businessLicenseNo'} className="input-weak" type="text" placeholder="营业执照号码" />
						}
					
				</li>
				<li>
					<h6 className="xert-h6 xert-h6-large02">道路运输许可证号码</h6>
						{
							if @state.user.transLicenseNo and @state.user.certification isnt 0
								<input value=@state.user.transLicenseNo readOnly="readOnly" className="input-weak" type="text" placeholder="道路运输许可证号码" />
							else
								<input valueLink={@linkState 'transLicenseNo'} className="input-weak" type="text" placeholder="道路运输许可证号码" />
						}
					
				</li>

				<li>
					<h6 className="xert-h6">公司电话</h6>
						{
							if @state.user.tel and @state.user.certification isnt 0
								<input value=@state.user.tel readOnly="readOnly" className="input-weak" type="text" placeholder="请输入公司电话" />
							else
								<input valueLink={@linkState 'tel'} className="input-weak" type="text" placeholder="请输入公司电话" />
						}
				</li>
			</ul>
		</div>
		<div className="m-file-upload m-file-many">
			{cells}
		</div>
		{
			if @state.user.carStatus in [0, 3]
				<div className="u-certBtn-con">
					<a className="u-btn" onClick={@_auth}>提交认证</a>
				</div>
		}

		</section>
}

React.render <Auth />, document.getElementById('content')

# <li>
# 	<h6 className="xert-h6 xert-h6-large01">组织资格代码证</h6>
# 		{
# 			if @state.user.organizingCode and @state.user.certification isnt 0
# 				<input value=@state.user.organizingCode readOnly="readOnly" className="input-weak" type="text" placeholder="请输入组织资格代码证" />
# 			else
# 				<input valueLink={@linkState 'organizingCode'} className="input-weak" type="text" placeholder="请输入组织资格代码证" />
# 		}
	
# </li>
