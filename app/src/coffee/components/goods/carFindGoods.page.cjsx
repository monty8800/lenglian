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

InfiniteScroll = require('react-infinite-scroll')(React)


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
		if msg.type #从selectionstore过来的
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
			@setState {
				goodsList: dataList
				hasMore: dataList.size - @state.dataCount >= @state.pageSize
				dataCount: dataList.size
			}

	_search: ->
		@_requestData 0

	_requestData: (page)->
		GoodsAction.searchGoods {
			startNo: @state.goodsList.size
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
			goodsList: GoodsStore.getGoodsList()
			pageSize: 4
			dataCount: 0
			hasMore: true
			showCarList: false
			bid: false
		}

		for selection in selectionList
			initState[selection.key] = (option.key for option in selection.options)
		console.log 'initState', initState
		return initState

# <InfiniteScroll
#     pageStart=0
#     loadMore={loadFunc}
#     hasMore={true || false}
#     loader={<div className="loader">Loading ...</div>}>
#   {items} // <-- This is the "stuff" you want to load
# </InfiniteScroll>
# pageStart : The page number corresponding to the initial items, defaults to 0 which means that for the first loading, loadMore will be called with 1

# loadMore(pageToLoad) : This function is called when the user scrolls down and we need to load stuff

# hasMore : Boolean stating if we should keep listening to scroll event and trying to load more stuff

# loader : Loader element to be displayed while loading stuff - You can use InfiniteScroll.setDefaultLoader(loader); to set a defaut loader for all your InfiniteScroll components

# threshold : The distance between the bottom of the page and the bottom of the window's viewport that triggers the loading of new stuff - Defaults to 250

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
			</ul>
			
		</div>

		<InfiniteScroll pageStart=0 loadMore={@_requestData} hasMore={@state.hasMore}>
		{ goodsCells }
		</InfiniteScroll>
		</section>
}


React.render <CarFindGoods  />, document.getElementById('content')


