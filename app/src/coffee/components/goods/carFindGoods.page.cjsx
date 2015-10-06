require 'components/common/common'
require 'index-style'

React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'

GoodsStore = require 'stores/goods/goods'

GoodsAction = require 'actions/goods/goods'

FromTo = require 'components/goods/fromTo'

Helper = require 'util/helper'

UserStore = require 'stores/user/user'

Selection = require 'components/common/selection'
SelectionStore = require 'stores/common/selection'

CarFindGoodsCell = require 'components/goods/carFindGoodsCell'

CarListWidget = require 'components/goods/carListWidget'

OrderStore = require 'stores/order/order'


selectionList = [
	{
		key: 'goodsType'
		value: '货物类型'
		options: [
			{key: '1', value: '常温'}
			{key: '2', value: '冷藏'}
			{key: '3', value: '冷冻'}
			{key: '4', value: '急冻'}
			{key: '5', value: '深冷'}
		]
	}
	{
		key: 'priceType'
		value: '价格类型'
		options: [
			{key: '1', value: '一口价'}
			{key: '2', value: '竞价'}
		]
	}
	{
		key: 'invoiceType'
		value: '可开发票'
		options: [
			{key: '1', value: '可开发票'}
			{key: '2', value: '不可开发票'}
		]
	}

]

CarFindGoods = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		GoodsStore.addChangeListener @_change
		SelectionStore.addChangeListener @_change
		@_search()

	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_change
		SelectionStore.removeChangeListener @_change
		GoodsAction.clearGoods()

	_change: (msg)->
		console.log 'event change ', msg
		if msg.type #从selectionstore过来的
			newState = Object.create @state
			newState[msg.type] = msg.list
			console.log 'newState', newState
			# @setState newState
		else if msg.msg is 'change:widget:status'
			newState = Object.create @state
			newState.showCarList = msg.show
			@setState newState


	_search: ->
		GoodsAction.searchGoods {
			startNo: @state.startNo
			pageSize: @state.pageSize
			goodsType: @state.goodsType
			fromProvinceId: @state.fromProvinceId if @state.fromProvinceId
			fromCityId: @state.fromCityId if @state.fromCityId
			fromAreaId: @state.fromAreaId if @state.fromAreaId
			priceType: @state.priceType[0] if @state.priceType.length is 1
			isInvoice: @state.invoiceType[0] if @state.invoiceType.length is 1 
		}

	getInitialState: ->
		initState = {
			fromProvince: null
			fromProvinceId: null
			fromCity: null
			fromCityId: null
			fromArea: null
			fromAreaId: null
			startNo: 0
			pageSize: 10
			showCarList: false
		}

		for selection in selectionList
			initState[selection.key] = (option.key for option in selection.options)
		console.log 'initState', initState
		return initState

	render: ->
		console.log 'state', @state

		<section>
		<div className="m-nav03">
			<ul>
				{
					for s, i in selectionList
						<Selection selectionMap=s  key={i} />
				}
			</ul>
			
		</div>
		<CarFindGoodsCell />
		<CarListWidget show={@state.showCarList} goodsId="968a935c845440d897abb979a367b8b8" />
		</section>
}


React.render <CarFindGoods  />, document.getElementById('content')


