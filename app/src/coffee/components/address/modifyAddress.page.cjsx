require 'components/common/common'
require 'index-style'

React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'
DB = require 'util/storage'
transData = DB.get 'transData'
DB.remove 'transData'
Validator = require 'util/validator'


Address = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		address = AddressStore.getAddress()
		transAddress = transData?.provinceName + transData?.cityName + transData?.areaName if transData?.areaName
		localAddress = address.provinceName + address.cityName + address.areaName if address.areaName
		{
			id: transData?.id if transData?.id
			provinceName: transData?.provinceName or address.provinceName
			cityName: transData?.cityName or address.cityName
			areaName: transData?.areaName or address.areaName
			address: transAddress or localAddress or ''
			street: transData?.street or address.street or ''
			lati: transData?.latitude or address.lati or null
			longi: transData?.longitude or  address.longi or null
		}

	componentDidMount: ->
		AddressStore.addChangeListener @_change
		AddressAction.locate() if not transData?.id and not AddressStore.getAddress()?.lati


	componentWillUnMount: ->
		AddressStore.removeChangeListener @_change


	_locate: ->
		Plugin.nav.push ['location']

	_submit: ->
		if not @state.longi or not @state.lati 
			Plugin.toast.err '请在地图上选择地区！'
		else if not Validator.street @state.street
			Plugin.toast.err '详细地址应该在1-20位之间！'
		else
			user = UserStore.getUser()
			params = {
				userId: user.id
				longitude: @state.longi
				latitude: @state.lati
				street: @state.street
				province: @state.provinceName
				city: @state.cityName
				area: @state.areaName
				id: @state.id if @state.id
			}
			if params.id
				AddressAction.editAddress params
			else
				AddressAction.newAddress params
			

	_change: (arg)->
		console.log 'change arg', arg
		if arg is 'address:update'
			address = AddressStore.getAddress()
			@setState {
				id: @state.id if @state.id
				lati: address.lati
				longi: address.longi
				provinceName: address.provinceName
				cityName: address.cityName
				areaName: address.areaName
				address: address.provinceName + address.cityName + address.areaName
				street: address.street
			}
		else if arg is 'address:edit:success'
			Plugin.toast.success '修改地址成功！'
			Plugin.nav.pop()
		else if arg is 'address:new:success'
			Plugin.toast.success '添加地址成功！'
			Plugin.nav.pop()
	render: ->
		<div>
			<div className="m-adr-ed">
				<ul>
					<li className="adr-ed-fir" onClick={@_locate}>
						<span>选择地区</span>
						<input value={@state.address} readOnly="readOnly" type="text" placeholder="请选择地区" />
						<em>点击定位</em>
					</li>
					<li>
						<span>详细地址</span>
						<textarea valueLink={@linkState 'street'}  placeholder="请填写详细地址"></textarea>
					</li>
				</ul>
			</div>
			
			<div className="u-certBtn-con">
				<a onClick={@_submit} className="u-btn">确定</a>
			</div>
		</div>
}

React.render <Address />, document.getElementById('content')