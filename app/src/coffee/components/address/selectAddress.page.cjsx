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

CitySelector = require 'components/address/citySelector'

_addressFromSelector = false

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
				Plugin.toast.err '请填写正确的详细地址，最多20位'
			else
				if _addressFromSelector
					Plugin.run [19, @state.cityName, @state.areaName + @state.street]
				else
					@_doSubmit()

		window.selectCurrent = selectCurrent.bind this
		window.doSubmit = @_doSubmit.bind this

	_doSubmit: (lati, longi)->
		#根据上个界面放在transddata中的key，把数据放在value里传回去
		data = {}
		address = AddressStore.getAddress()
		address.merge {
			lati: lati
			longi: longi
		} if lati and longi
		address = address.set 'street', @state.street
		data[transData] = address.toJS()
		DB.put 'transData', data
		console.log 'trans____Data----', data
		Plugin.nav.pop()
				

	componentWillUnMount: ->
		AddressStore.removeChangeListener @_change

	_locate: ->
		Plugin.nav.push ['location']

	_select: ->
		console.log 'select city'
		AddressAction.changeSelector 'show'

	_toAddAddress:->
		Plugin.nav.push ['toAddAddress']

	_change: (arg)->
		console.log 'change arg', arg
		if arg is 'address:update'
			address = AddressStore.getAddress()
			console.log 'address after update is', address
			_addressFromSelector = false
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
			console.log '-------------data:', data
			DB.put 'transData', data
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
		<section>
		<div className="m-releasehead02">
			<div  className="g-adr-item u-arrow-right ll-font">
				<span onClick={@_select}>{@state.address}</span>
				<span onClick={@_locate} className="g-adr-btn02">点击定位</span>
			</div>
			<div className="g-adr-item">
				<input type="text" valueLink={@linkState 'street'} className="input-weak" placeholder="详细地址" />
			</div>
		</div>
		<AddressList />
		<div onClick={@_toAddAddress} className="u-adr-btn">添加常用地址</div>		
		<CitySelector />
		</section>
}

React.render <SelectAddress />, document.getElementById('content')
