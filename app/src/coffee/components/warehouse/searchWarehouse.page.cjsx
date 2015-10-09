require 'components/common/common'
require 'index-style'
require 'majia-style'
ImageHelper = require 'util/image'

React = require 'react/addons'
Moment = require 'moment'
headerImg = require 'user-01.jpg'
WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
XeImage = require 'components/common/xeImage'

PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

Plugin = require 'util/plugin'

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
		value: '需要发票'
		options: [
			{key: '1', value: '提供发票'}
			{key: '2', value: '不提供发票'}
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
			showGoodsListMenu:0
			startNo: 0
			pageSize: 10
			resultCount:-1
		}

		for selection in selectionList
			initState[selection.key] = '' #(option.key for option in selection.options)
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
		else if mark is "getUserGoodsListSucc"
			newState = Object.create @state
			newState.showGoodsListMenu = 1
			newState.userGoodsSource = GoodsStore.getMyGoodsList()
			@setState newState
		else if mark is 'goods_bind_warehouse_order_succ'
			Plugin.toast.show 'bind success'

		else if mark is 'do:search:warehouse'
			@_doSearchWarehouse()

		else if mark.type
			newState = Object.create @state
			newState[mark.type] = mark.list
			console.log '__selection_newState', newState
			@setState newState
		

	_resultItemClick:(aResult)->
		DB.put 'transData',{warehouseId:aResult.warehouseId,focusid:aResult.userId}
		Plugin.nav.push ['searchWarehouseDetail']

	_selectWarehouse :(index) ->
		# if @state.userGoodsSource.length < 1
		# 	Plugin.toast.show '没有货源适合这个仓库'
		# 	return
		_selectedWarehouseId = @state.searchResult[index].id
		console.log _selectedWarehouseId,'____库源ID_'
		# GoodsAction.getGoodsList '0','10','1'		#1 求库中的货源
		Plugin.run [3, 'select:goods', _selectedWarehouseId]

	_selectGoods :(index) ->
		Plugin.toast.show 'select goods'
		goodsId = @state.userGoodsSource[index].id
		console.log goodsId,'____货源ID_'
		_selectedWarehouseId = '295dd8ab5f6442afae2542175efdba1e'
		GoodsAction.bindWarehouseOrder _selectedWarehouseId,goodsId
		_selectedWarehouseId = ''
		newState = Object.create @state
		newState.showGoodsListMenu = 0 
		@setState newState

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
								<span>{ aResult.name }</span><span className="g-dirname-single">(个体)</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a onClick={ @_selectWarehouse.bind this,i } className="u-btn02">选择该仓库</a>
						</div>
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
				<div className="g-item g-pad ll-font">
					价格类型 : 竞价
					<span>( 柠静  4999元 )</span>
				</div>
				<div className="g-item g-item-des">
					<p>仓库类型 : <span>{ aResult.wareHouseType }</span></p>
					<p>库温类型 : <span>{ aResult.cuvinType }</span></p>
					<p>仓库价格 : <span>{ aResult.price }</span></p>
				</div>
			</div>
		, this

		goodsLists = @state.userGoodsSource.map (aResult, i)->
			<div className="u-content" onClick={@_selectGoods.bind this,i}>
				<div className="u-content-item ll-font">
					<div className="u-address">
						<div className="g-adr-start ll-font g-adr-start-line">
							{
								if aResult.toProvinceName is aResult.toCityName
									aResult.toCityName + aResult.toAreaName + aResult.toStreet
								else
									aResult.toProvinceName + aResult.toCityName + aResult.toAreaName + aResult.toStreet
							}
						</div>
						<div className="g-adr-end ll-font g-adr-end-line">
							{
								if aResult.fromProvinceName is aResult.fromCityName
									aResult.fromCityName + aResult.fromAreaName + aResult.fromStreet
								else
									aResult.fromProvinceName + aResult.fromCityName + aResult.fromAreaName + aResult.fromStreet
							}
						</div>
					</div>
					<p>价格类型:一口价 4000元</p>
					<p>货物描述:小鲜肉 1吨 冷鲜肉</p>
				</div>
			</div>
		,this

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
			{ searchResultList }
			<div className={ if @state.showGoodsListMenu is 1 then "u-pop-box u-show" else "u-pop-box" }>
				{ goodsLists }
			</div>
			<div className={ if @state.showGoodsListMenu is 1 then "u-mask-grid show" else "u-mask-grid" }></div>

		</div>
}

React.render <SearchWarehouse />, document.getElementById('content')


