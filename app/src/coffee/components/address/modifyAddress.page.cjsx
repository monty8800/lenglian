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

CitySelector = require 'components/address/citySelector'

_addressFromSelector = false


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
		window.doSubmit = @_doSubmit.bind this


	componentWillUnMount: ->
		AddressStore.removeChangeListener @_change


	_locate: ->
		Plugin.nav.push ['location']

	_select: ->
		console.log 'select city'
		AddressAction.changeSelector 'show'

	_submit: ->
		if not @state.address
			Plugin.toast.err '请选择省市区，或在地图上定位！'
		else if not Validator.street @state.street
			Plugin.toast.err '详细地址应该在1-20位之间！'
		else
			if _addressFromSelector
				Plugin.run [19, @state.cityName, @state.areaName + @state.street]
			else
				@_doSubmit()

	_doSubmit: (lati, longi)->
		user = UserStore.getUser()
		addressLati = lati or @state.lati
		addressLongi = longi or @state.longi
		params = {
			userId: user.id
			longitude: addressLongi if addressLongi
			latitude: addressLati if addressLati
			street: @state.street
			province: @state.provinceName
			city: @state.cityName
			area: @state.areaName
			id: @state.id if @state.id
		}
		console.log 'submit address to server', params
		if params.id
			AddressAction.editAddress params
		else
			AddressAction.newAddress params		

	_change: (arg)->
		console.log 'change arg', arg
		if arg is 'address:update'
			address = AddressStore.getAddress()
			_addressFromSelector = false
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
			Plugin.nav.push ['modify_success']
			Plugin.nav.pop()
		else if arg is 'address:new:success'
			Plugin.toast.success '添加地址成功！'
			Plugin.nav.push ['add_success']
			DB.put 'shouldReloadAddressList',1
			Plugin.nav.pop()
		else if arg.msg is 'address:changed' and arg.type is 'area'
			address = AddressStore.getAddress()
			console.log 'new address---', address
			_addressFromSelector = true
			@setState {
				provinceName: address.provinceName
				cityName: address.cityName
				areaName: address.areaName
				address: address.provinceName + address.cityName + address.areaName
				street: ''
			}

	render: ->
		<div>
			<div className="m-adr-ed">
				<ul>
					<li className="adr-ed-fir" >
						<span>选择地区</span>
						<input onClick={@_select} value={@state.address} readOnly="readOnly" type="text" placeholder="请选择地区" />
						<em onClick={@_locate}>点击定位</em>
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
			<CitySelector />
		</div>
}

React.render <Address />, document.getElementById('content')
