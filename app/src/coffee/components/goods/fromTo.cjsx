require 'components/common/common'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

Plugin = require 'util/plugin'

DB = require 'util/storage'
GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'


FromTo = React.createClass {
	mixins: [PureRenderMixin]
	componentDidMount: ->
		GoodsStore.addChangeListener @_change

	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_change

	_selectAddress: (type)->
		console.log 'select ', type
		DB.put 'transData', type
		Plugin.nav.push ['selectAddress']

	_addPassBy: ->
		if @props.type is 'addGoods'
			GoodsAction.addPassBy()


	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'goods:update'
			@setState {
				from: GoodsStore.getFrom()
				to: GoodsStore.getTo()
				passBy: GoodsStore.getPassBy()
			}

	getInitialState: ->
		{
			from: GoodsStore.getFrom
			to: GoodsStore.getTo
			passBy: GoodsStore.getPassBy()
		}
	render: ->
		console.log 'state---', @state
		passBy = @state.passBy.toArray().map (address, i)->
			<div key={i} onClick={@_selectAddress.bind this,  'passBy' + i} className="g-adr-middle ll-font">
				<input value={if address.lati then address.provinceName + address.cityName + address.areaName + address.street else ''} readOnly="readOnly" type="type" placeholder="途径地"/>
			</div>
		,this

		<div  className="m-releasehead ll-font">
			<div onClick={@_selectAddress.bind this, 'to'} className="g-adr-end ll-font g-adr-end-line">
				<input readOnly="readOnly" type="type" value={if @state.to.lati then @state.to.provinceName + @state.to.cityName + @state.to.areaName + @state.to.street else ''} placeholder="输入终点"/>
			</div>
			{passBy}
			<div onClick={@_selectAddress.bind this, 'from'} className="g-adr-start ll-font g-adr-start-line">
				<input readOnly="readOnly" type="type" value={if @state.from.lati then @state.from.provinceName + @state.from.cityName + @state.from.areaName + @state.from.street else ''} placeholder="输入起点"/>
			</div>
			<a onClick={@_addPassBy} className="u-addIcon"></a>
		</div>
}


module.exports = FromTo


