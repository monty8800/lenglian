require 'components/common/common'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'

Plugin = require 'util/plugin'

AddressList = require 'components/address/myAddressList'

Validator = require 'util/validator'

DB = require 'util/storage'

transData = DB.get 'transData' #这里是个字符串，如 from,to,by0,by1
detailStreet = ''

SelectAddress = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		address = AddressStore.getAddress()
		{
			lati: address.lati
			longi: address.longi
			address: if address.areaName then address.provinceName + address.cityName + address.areaName else '选择地区'
			street: address.street or ''
		}
	componentDidMount: ->
		AddressStore.addChangeListener @_change
		AddressAction.locate() if not AddressStore.getAddress()?.lati

		selectCurrent = ->
			address = AddressStore.getAddress()
			if not address.lati
				Plugin.toast.err '请选择城市'
			else if not Validator.street @state.street
				Plugin.toast.err '请填写详细地址'
			else		
				#根据上个界面放在transddata中的key，把数据放在value里传回去
				data = {}
				address = address.set 'street', @state.street
				data[transData] = address.toJS()
				DB.put 'transData', data
				console.log 'trans____Data----', data
				Plugin.nav.pop()
		window.selectCurrent = selectCurrent.bind this
				

	componentWillUnMount: ->
		AddressStore.removeChangeListener @_change

	_locate: ->
		Plugin.nav.push ['location']

	_change: (arg)->
		console.log 'change arg', arg
		if arg is 'address:update'
			address = AddressStore.getAddress()
			console.log 'address after update is', address
			@setState {
				lati: address.lati
				longi: address.longi
				address: address.provinceName + address.cityName + address.areaName
				street: address.street or ''
			}
		else if arg.msg is 'address:select'
			#根据上个界面放在transddata中的key，把数据放在value里传回去
			data = {}
			data[transData] = arg.address.toJS()
			DB.put 'transData', data
			Plugin.nav.pop()
	render: ->
		<section>
		<div className="m-releasehead02 ll-font">
			<div onClick={@_locate} className="g-adr-item u-arrow-right ll-font">
				{@state.address}
			</div>
			<div className="g-adr-item">
				<input type="text" valueLink={@linkState 'street'} className="input-weak" placeholder="详细地址" />
			</div>
		</div>
		<AddressList />	
		</section>
}

React.render <SelectAddress />, document.getElementById('content')
