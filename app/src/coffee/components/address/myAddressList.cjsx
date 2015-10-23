require 'anim-style'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'

AddressList = React.createClass {
	mixins: [PureRenderMixin]

	getInitialState: ->
		{
			addressList: AddressStore.getAddressList()
		}

	componentDidMount: ->
		AddressStore.addChangeListener @_change
		AddressAction.addressList()

	componentWillUnMount: ->
		AddressStore.removeChangeListener @_change

	_select: (address)->
		AddressAction.selectAddressInList address
	_change: (arg)->
		console.log 'my address list change arg', arg
		if arg is 'list'
			@setState {
				addressList: AddressStore.getAddressList()
			}
	render: ->
		console.log 'addressList', @state.addressList.toJS()
		addressList = @state.addressList?.map (address, i)->
			<div key={i} onClick={@_select.bind this, address}>{address.provinceName + address.cityName + address.areaName + address.street}</div>
		, this
		<div className="m-releaseitem">
			<div className="title">常用地址</div>
				{addressList}
		</div>	
}

module.exports = AddressList
