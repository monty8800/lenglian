require 'address-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'

Plugin = require 'util/plugin'

#TODO: 有bug！！点击偶尔会出现空的列表

Page = React.createClass {
	_select: (type, item)->
		console.log 'select', item
		switch type
			when 'province'
				AddressAction.selectAddress {
					provinceName: item.get 'v'
					provinceId: item.get 'k'
				}, type, item
			when 'city'
				AddressAction.selectAddress {
					cityName: item.get 'v'
					cityId: item.get 'k'
				}, type, item
			when 'area'
				AddressAction.selectAddress {
					areaName: item.get 'v'
					areaId: item.get 'k'
				}, type, item
	render: ->
		itemList = @props.list?.map (item, i)->
			<li onClick={@_select.bind this, @props.type, item}  key={i} className={'active' if @props.selectId is item.get 'k'}>{item.get 'v'}</li>
		, this

		<ul>{itemList}</ul>
}


Selector = React.createClass {
	getInitialState: ->
		{
			deepth: 0
			show: false
		}
	componentDidMount: ->
		AddressStore.addChangeListener @_change
		AddressAction.cityList()
  
	componentWillUnMount: ->
		AddressStore.removeChangeListener @_change

	_back: ->
		newState = Object.create @state
		newState.deepth--
		@setState newState

	_close: ->
		AddressAction.changeSelector('hide')

	_change: (arg)->
		console.log 'change arg', arg
		provinceList = AddressStore.getCityList()
		address = AddressStore.getAddress()

		if arg.msg is 'cityList:changed'
			console.log 'provinceList---', provinceList
			cityList = provinceList.first().get 'rl'
			areaList = cityList.first().get 'rl'
			console.log 'cityList---', cityList
			console.log 'areaList----', areaList
			@setState {
				deepth: 0
				provinceList: provinceList
				cityList: cityList
				areaList: areaList
				address: address
				show: @state.show
			}
		else if arg.msg is 'address:changed'
			switch arg.type
				when 'province'
					cityList = arg.item?.get 'rl'
					areaList = cityList?.first()?.get 'rl'
					@setState {
						deepth: 1
						provinceList: provinceList
						cityList: cityList
						areaList: areaList
						address: address
						show: true
					}
				when 'city'
					areaList = arg.item?.get 'rl'
					@setState {
						deepth: 2
						provinceList: provinceList
						cityList: @state.cityList
						areaList: areaList
						address: address
						show: true
					}
				when 'area'
					@setState {
						deepth: 0
						provinceList: provinceList
						cityList: @state.cityList
						areaList: @state.areaList
						address: address
						show: false
					}
		else if arg is 'selector:show'
			newState = Object.create @state
			newState.show = true
			@setState newState
		else if arg is 'selector:hide'
			newState = Object.create @state
			newState.show = false
			@setState newState

	render: ->
		<section style={{display: if @state.show then 'block' else 'none'}}>
		    <div className="chadr_box">
		        <div className="chadr_topbar">
		            <div onClick={@_back} className="ll-font arrow-left"></div>
		            请选择城市
		            <div onClick={@_close} className="ll-font ch-close"></div>
		        </div>
		        <div className="chadr_con">
	            	<div className={'ul_con deepth' + @state.deepth}>
	            		<Page list={@state.provinceList} selectId={@state.address?.provinceId} type='province' />
	            		<Page list={@state.cityList} selectId={@state.address?.cityId} type='city' />
	            		<Page list={@state.areaList} selectId={@state.address?.areaId} type='area' />
	            	</div>
		        </div>
		    </div>
		</section>
}

module.exports = Selector