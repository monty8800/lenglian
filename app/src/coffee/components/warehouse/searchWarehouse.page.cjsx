require 'components/common/common'
require 'index-style'
require 'majia-style'
ImageHelper = require 'util/image'
Auth = require 'util/auth'
React = require 'react/addons'
Moment = require 'moment'
headerImg = require 'user-01.jpg'
WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
XeImage = require 'components/common/xeImage'
UserStore = require 'stores/user/user'
Helper = require 'util/helper'

PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

Plugin = require 'util/plugin'
Raty = require 'components/common/raty'

Selection = require 'components/common/selection'
SelectionStore = require 'stores/common/selection'

_selectedWarehouseId = ''


selectionList = [
	{
		key: 'wareHouseType'
		value: '仓库类型'
		options: [
			{key: '1', value: '驶入式'}
			{key: '2', value: '横梁式'}
			{key: '3', value: '平推式'}
			{key: '4', value: '自动立体货架式'}
		]
	}
	{
		key: 'cuvinType'
		value: '库温类型'
		options: [
			{key: '1', value: '常温'}
			{key: '2', value: '冷藏'}
			{key: '3', value: '冷冻'}
			{key: '4', value: '急冻'}
			{key: '5', value: '深冷'}
		]
	}
	{
		key: 'isInvoice'
		value: '提供发票'
		options: [
			{key: '1', value: '是'}
			{key: '2', value: '否'}
		]
	}
]

SearchWarehouse = React.createClass {
	_doSearchWarehouse: ->
		WarehouseAction.searchWarehouse {
			startNo: @state.startNo
			pageSize: @state.pageSize
			cuvinType: @state.cuvinType
			wareHouseType: @state.wareHouseType
			isInvoice: @state.isInvoice[0] if @state.isInvoice.length is 1 
		}
	getInitialState: ->
		initState = {
			searchResult:[]
			userGoodsSource:[]
			startNo: 0
			pageSize: 10
			resultCount:-1
		}

		for selection in selectionList
			initState[selection.key] = ''
		console.log 'initState', initState

		return initState

	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		GoodsStore.addChangeListener @_onChange
		SelectionStore.addChangeListener @_onChange
		@_doSearchWarehouse()
		
	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange
		GoodsStore.removeChangeListener @_onChange
		SelectionStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark is 'searchWarehouseSucc'
			newState = Object.create @state
			newState.searchResult = WarehouseStore.getWarehouseSearchResult()
			newState.resultCount = newState.searchResult.length
			@setState newState

		else if mark is 'do:search:warehouse'
			@_doSearchWarehouse()

		else if mark.type
			newState = Object.create @state
			newState[mark.type] = mark.list
			console.log '__selection_newState', newState
			@setState newState
		
	_resultItemClick:(aResult)->
		Auth.needLogin ->
			DB.put 'transData',{warehouseId:aResult.warehouseId,focusid:aResult.userId}
			Plugin.nav.push ['searchWarehouseDetail']

	_selectWarehouse :(aResult,e) ->
		Auth.needLogin ->
			user = UserStore.getUser()
			if user.id is aResult.userId
				Plugin.toast.err '不能选择自己的仓库'
			else
				if user.goodsStatus is 1
	#TODO:弹出选择货物的弹窗前 先判断有没有货
					_selectedWarehouseId = aResult.id
					Plugin.run [3, 'select:goods', _selectedWarehouseId]
				else 
					Plugin.toast.err '尚未通过货主认证，请认证后再试'
		e.stopPropagation()

	_loadMore : ->
		WarehouseAction.searchWarehouse {
			startNo: @state.startNo
			pageSize: @state.pageSize
			cuvinType: @state.cuvinType
			wareHouseType: @state.wareHouseType
			isInvoice: @state.isInvoice[0] if @state.isInvoice.length is 1 
		}

	render: ->
		searchResultList = @state.searchResult.map (aResult, i)->
			<div className="m-item01 m-item03" onClick={ @_resultItemClick.bind this,aResult } >
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<XeImage src={ aResult.userImgUrl } size='100x100' type='avatar'/>
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ aResult.name }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper aResult.certificAtion }</span>
							</div>
							<div className="g-dirver-dis ll-font">
								<Raty score={ aResult.score } />
							</div>
						</div>
						{
							# user = UserStore.getUser()
							# if user.id is aResult.userId
							# else
								<div className="g-dirver-btn">
									<a onClick={ @_selectWarehouse.bind this,aResult } className="u-btn02">选择该仓库</a>
								</div>
						}
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-store ll-font">
						{ 
							if aResult.provinceName is aResult.cityName
								aResult.provinceName + aResult.areaName
							else
								aResult.provinceName + aResult.cityName + aResult.areaName 
						}
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>仓库类型 : <span>{ aResult.wareHouseType }</span></p>
					<p>库温类型 : <span>{ aResult.cuvinType }</span></p>
					<p>仓库价格 : <span>{ aResult.price }</span></p>
				</div>
			</div>
		, this

		<div>
			<div className="m-nav03">
				<ul>
					{
						for s, i in selectionList
							<Selection selectionMap=s  key={i} />
					}
				</ul>			
			</div>
			<div style={{display: if @state.resultCount is 0 then 'block' else 'none'}} className="m-searchNoresult">
				<div className="g-bgPic"></div>
				<p className="g-txt">很抱歉，没能找到您要的结果</p>
			</div>
			# <InfiniteScroll pageStart=1 loadMore={@_loadMore} hasMore={@state.hasMore}>
				{ searchResultList }
			# </InfiniteScroll>
			

		</div>
}

React.render <SearchWarehouse />, document.getElementById('content')


