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

# CarListWidget = require 'components/goods/carListWidget'

OrderStore = require 'stores/order/order'

DB = require 'util/storage'

AddressSelector = require 'components/address/citySelector'

InfiniteScroll = require('react-infinite-scroll')(React)

AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'

Helper = require 'util/helper'


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
		value: '需要发票'
		options: [
			{key: '1', value: '是'}
			{key: '2', value: '否'}
		]
	}

]

#TODO: 分页还是有点问题
_skip = 0
_pageSize = 10
_hasMore = true
_netBusy = false

CarFindGoods = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		GoodsStore.addChangeListener @_change
		# SelectionStore.addChangeListener @_change
		#如果是金价，原生弹窗选择完后调用这个函数
		window.goBid = (carId, goodsId)->
			DB.put 'transData', {
				carId: carId
				goodsId: goodsId
			}
			Plugin.nav.push ['carBidGoods']
		@_search()

	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_change
		# SelectionStore.removeChangeListener @_change
		GoodsAction.clearGoods()

	_change: (msg)->
		console.log 'event change ', msg
		if msg.type and msg.type isnt 'area' #从selectionstore过来的
			newState = Object.create @state
			newState[msg.type] = msg.list
			console.log 'newState', newState
			@setState newState
		else if msg.msg is 'change:widget:status'
			newState = Object.create @state
			newState.showCarList = msg.show
			newState.bid = msg.bid
			@setState newState
		else if msg is 'do:car:search:goods'
			@_search()
		else if msg is 'search:goods:done'
			dataList = GoodsStore.getGoodsList()
			_netBusy = false
			_skip = dataList.size
			_hasMore = (dataList.size % _pageSize) is 0
			@setState {
				goodsList: dataList
			}
		else if msg.msg is 'address:changed' and msg.type is 'area'
			address = AddressStore.getAddress()
			console.log 'new address---', address
			@setState {
				fromProvince: address.provinceName
				fromCity: address.cityName
				fromArea: address.areaName
				fromProvinceId: address.provinceId
				fromCityId: address.cityId
				fromAreaId: address.areaId
			}

	_search: ->
		_skip = 0
		_hasMore = true
		_netBusy = false
		@_requestData()

	_requestData: (page)->
		if _netBusy
			console.log 'net busy, return'
			return
		_netBusy = true

		GoodsAction.searchGoods {
			startNo: _skip
			pageSize: _pageSize
			goodsType: @state.goodsType
			fromProvinceId: @state.fromProvinceId if @state.fromProvinceId
			fromCityId: @state.fromCityId if @state.fromCityId
			fromAreaId: @state.fromAreaId if @state.fromAreaId
			priceType: @state.priceType[0] if @state.priceType.length is 1
			isInvoice: @state.invoiceType[0] if @state.invoiceType.length is 1 
		}

	_showAddressSelector: ->
		AddressAction.changeSelector 'show'

	getInitialState: ->
		initState = {
			fromProvince: null
			fromProvinceId: null
			fromCity: null
			fromCityId: null
			fromArea: null
			fromAreaId: null
			goodsList: GoodsStore.getGoodsList()
			showCarList: false
			bid: false
		}

		for selection in selectionList
			initState[selection.key] = (option.key for option in selection.options)
		console.log 'initState', initState
		return initState

	render: ->
		console.log 'state', @state
		goodsCells = @state.goodsList?.map (goods, i)->
			<CarFindGoodsCell goods={goods} key={i} />

		<section>
		<div className="m-nav03">
			<ul>
				{
					for s, i in selectionList
						<Selection selectionMap=s  key={i} />
				}

				<li>
					<div onClick={@_showAddressSelector} className="g-div01 ll-font u-arrow-right" dangerouslySetInnerHTML={{__html: "发货地点<span>" + (if @state.fromAreaId then Helper.maxLength(@state.fromProvince + @state.fromCity + @state.fromArea, 8) else '全部') + "</span>"}}>		
					</div>
				</li>
			</ul>
			
		</div>

		<InfiniteScroll pageStart=0 loadMore={@_requestData} hasMore={_hasMore and not _netBusy}>
		{ goodsCells }
		</InfiniteScroll>

		<AddressSelector />
		</section>
}


React.render <CarFindGoods  />, document.getElementById('content')


