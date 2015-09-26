require 'components/common/common'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'

Plugin = require 'util/plugin'

CitySelector = require 'components/address/citySelector'


#TODO:  常用地址经纬度的问题，有待跟产品确认
SelectAddress = React.createClass {
	mixins: [PureRenderMixin]
	getInitialState: ->
		address = AddressStore.getAddress()
		{
			lati: address.lati
			longi: address.longi
			address: address.geoAddress or '选择地区'
			street: address.geoStreet or '详细地址（点击地图选择）'
		}
	componentDidMount: ->
		AddressStore.addChangeListener @_change
		AddressAction.locate()

	componentWillUnMount: ->
		AddressStore.removeChangeListener @_change

	_locate: ->
		Plugin.nav.push ['location']

	_change: (arg)->
		console.log 'change arg', arg
		if arg is 'address:update'
			address = AddressStore.getAddress()
			@setState {
				lati: address.lati
				longi: address.longi
				address: address.geoAddress
				street: address.geoStreet
			}
	render: ->
		<section>
		<div onClick={@_locate} className="m-releasehead02 ll-font">
			<div className="g-adr-item u-arrow-right ll-font">
				{@state.address}
			</div>
			<div className="g-adr-item">
				{@state.street}
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="title">常用地址</div>
			<div>北京市海淀区中关村泰鹏大厦</div>
			<div>北京市海淀区中关村泰鹏大厦</div>
			<div>北京市海淀区中关村泰鹏大厦</div>
		</div>	
		<CitySelector />
		</section>
}

React.render <SelectAddress />, document.getElementById('content')