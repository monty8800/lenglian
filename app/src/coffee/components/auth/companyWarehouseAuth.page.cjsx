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

AddressStore = require 'stores/address/address'

AddressAction = require 'actions/address/address'

AddressSelector = require 'components/address/citySelector'


Auth = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change
		DB.remove 'transData'

	_showSelector: ->
		user = UserStore.getUser()
		if not user.warehouseAddress or user.enterpriseWarehouseStatus is 2 or user.enterpriseWarehouseStatus is '' or user.enterpriseWarehouseStatus is 'null' or user.enterpriseWarehouseStatus is undefined
			AddressAction.changeSelector 'show'		
		# if not user.address or user.certification is 0
		# 	AddressAction.changeSelector 'show'

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'setAuthPic:done'
			@setState {
				user: UserStore.getUser()
				companyName: @state.companyName
				address: @state.address
				street: @state.street
				tel: @state.tel
				businessLicenseNo: @state.businessLicenseNo
				# organizingCode: @state.organizingCode
			}
		else if msg is 'auth:done'
			UserAction.updateUser {
				company: @state.companyName
				warehouseStatus: 2
				enterpriseWarehouseStatus: 0
				certification: 2
				address: @state.address
				street: @state.street
				tel: @state.tel
				businessLicenseNo: @state.businessLicenseNo
				# organizingCode: @state.organizingCode
			}
		else if msg.msg is 'address:changed' and msg.type is 'area'
			address = AddressStore.getAddress()
			console.log 'address===', address
			newState = Object.create @state
			newState.address = address.provinceName + address.cityName + address.areaName
			@setState newState

	_auth: ->
		if not Validator.company @state.companyName
			Plugin.toast.err '请输入正确的公司名称'
		else if @state.address is '点击进行选择'
			Plugin.toast.err '请选择城市'
		else if not Validator.street @state.street
			Plugin.toast.err '详细地址范围1-20位'
		else if not Validator.tel @state.tel
			Plugin.toast.err '请输入正确的固定电话'
		# else if not Validator.organizingCode @state.organizingCode
		# 	Plugin.toast.err '请输入正确的组织资格代码'
		else if not Validator.businessLicenseNo @state.businessLicenseNo
			Plugin.toast.err '请输入正确的营业执照'
		else if not @state.user.businessLicense
			Plugin.toast.err '请上传营业执照照片'
		else
			address = AddressStore.getAddress()
			UserAction.companyAuth {
				type: Constants.authType.WAREHOUSE
				name: @state.companyName
				province: address.provinceName
				city: address.cityName
				area: address.areaName
				street: @state.street
				phone: @state.tel
				licenseno: @state.businessLicenseNo
				# certifies: @state.organizingCode
				userId: @state.user.id
			}, [
				{
					filed: 'businessLicenseImg'
					path: @state.user.businessLicense
				}
			]

	getInitialState: ->
		user = UserStore.getUser()
		{
			user: user
			companyName: user.company or ''
			address: user.warehouseAddress or '点击进行选择'
			street: user.warehouseStreet or ''
			tel: user.tel or ''
			businessLicenseNo: user.businessLicenseNo or ''
			# organizingCode: user.organizingCode or ''
		}
	render: ->
		cells = [
			{
				name: '营业执照'
				url: @state.user.businessLicense
				optional: false
				type: 'businessLicense'
			}
		].map (cell, i)->
			isOpt = @state.user?.enterpriseWarehouseStatus isnt 1 and @state.user?.enterpriseWarehouseStatus isnt 0
			<PicCell selectable={isOpt} key={i} type={cell.type} url={cell.url} name={cell.name} optional={cell.optional} />
		, this

		<section>
		<div className="m-cert-cons">
			<ul>
				<li>
					<h6 className="xert-h6">公司名称</h6>
						{
							if @state.user.company and @state.user.enterpriseWarehouseStatus is 1 or @state.user.enterpriseWarehouseStatus is 0
								<input className="input-weak" readOnly="readOnly" value=@state.user.company type="text" placeholder="请输入公司名" />
							else 
								<input className="input-weak"  valueLink={@linkState 'companyName'} type="text" placeholder="请输入公司名" />
						}
				</li>
				<li>
					<h6 className="xert-h6">所在城市</h6>
					<input readOnly="readOnly" onClick={@_showSelector} value={@state.address} className="input-weak cert-input-cityCh" type="text" />
				</li>
				<li>
					<h6 className="xert-h6">详细地址</h6>
						{
							if @state.user.warehouseStreet and @state.user.enterpriseWarehouseStatus is 1 or @state.user.enterpriseWarehouseStatus is 0
								<input readOnly="readOnly" value=@state.user.warehouseStreet className="input-weak" type="text" />
							else
								<input valueLink={@linkState 'street'} className="input-weak" type="text" placeholder="请输入详细地址" />
						}
				</li>
				<li>
					<h6 className="xert-h6">公司电话</h6>
						{
							if @state.user.tel and @state.user.enterpriseWarehouseStatus is 1 or @state.user.enterpriseWarehouseStatus is 0
								<input value=@state.user.tel readOnly="readOnly" className="input-weak" type="text" placeholder="请输入公司电话" />
							else
								<input valueLink={@linkState 'tel'} className="input-weak" type="text" placeholder="请输入公司电话" />
						}
				</li>
				<li>
					<h6 className="xert-h6 xert-h6-large02">营业执照号码</h6>
						{
							if @state.user.businessLicenseNo and @state.user.enterpriseWarehouseStatus is 1 or @state.user.enterpriseWarehouseStatus is 0
								<input value=@state.user.businessLicenseNo readOnly="readOnly" className="input-weak" type="text" placeholder="营业执照号码"/>
							else
								<input valueLink={@linkState 'businessLicenseNo'} maxLength="18" className="input-weak" type="text" placeholder="营业执照号码"/>
						}
				</li>
			</ul>
		</div>
		<div className="m-file-upload m-file-many">
			{cells}
		</div>
		{
			if @state.user.enterpriseWarehouseStatus isnt 1 and @state.user.enterpriseWarehouseStatus isnt 0
				<div className="u-certBtn-con">
					<a className="u-btn" onClick={@_auth}>提交认证</a>
				</div>
		}

		<AddressSelector />
		</section>
}

React.render <Auth />, document.getElementById('content')



# <li>
# 	<h6 className="xert-h6 xert-h6-large02">组织机构代码证号码</h6>
# 		{
# 			if @state.user.organizingCode and @state.user.certification isnt 0
# 				<input value=@state.user.organizingCode readOnly="readOnly" className="input-weak" type="text" placeholder="组织机构代码证号码"/>
# 			else
# 				<input valueLink={@linkState 'organizingCode'} className="input-weak" type="text" placeholder="组织机构代码证号码"/>
# 		}
# </li>