require 'components/common/common'
require 'index-style'
require 'majia-style'
require 'user-center-style'


React = require 'react/addons'

headerImg = require 'user-01.jpg'
WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'

Selection = require 'components/common/selection'
SelectionStore = require 'stores/common/selection'

PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

Plugin = require 'util/plugin'

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
		key: 'needWarehouseType'
		value: '需要仓库地'
		options: [
			{key: '1', value: '一口价'}
			{key: '2', value: '竞价'}
		]
	}
	{
		key: 'releaseTime'
		value: '发布时间'
		options: [
			{key: '1', value: '可开发票'}
			{key: '2', value: '不可开发票'}
		]
	}
	{
		key: 'invoiceType'
		value: '需要发票'
		options: [
			{key: '1', value: '可开发票'}
			{key: '2', value: '不可开发票'}
		]
	}
]

SearchResultList = React.createClass {

	render: ->
		console.log "*****____++++" + @props.list.length
		resultList = @props.list
		items = resultList.map (aResult,i) ->
			<div className="m-item01 m-item03">
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ aResult.userImgUrl }/>
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ aResult.name }</span><span className="g-dirname-single">(个体)</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a href="#" className="u-btn03">抢单</a>
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-start ll-font">
						<p dangerouslySetInnerHTML={{__html: 
							if aResult.toProvinceName is aResult.toCityName
								aResult.toProvinceName + aResult.toAreaName + aResult.street 
							else
								aResult.toProvinceName + aResult.toCityName + aResult.toAreaName + aResult.street 
						}}/>
					</div>
				</div>
				<div className="g-item g-pad ll-font">
					<p dangerouslySetInnerHTML={{__html:"价格类型 : 竞价"}}/> 
					<span>( 柠静  4999元 )</span>
				</div>
				<div className="g-item g-item-des">
					<p>车辆描述 : <span>10米</span><span>高栏</span></p>
				</div>
			</div>
		,this
		<div>
			{items}
		</div>
}

WarehouseSearchGoods = React.createClass {
	getInitialState: ->
		{
			searchResult:[]
			showGoodsTypeSelect:0
			showTargetLocationSelect:0
			showPostTimeSelect:0
			showInvoiceSelect:0
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		SelectionStore.addChangeListener @_onChange
		WarehouseAction.warehouseSearchGoods '0','10'

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange
		SelectionStore.removeChangeListener @_onChange
		
	_onChange: ->
		@setState { 
			searchResult:WarehouseStore.getWarehouseSearchGoodsResult()
			showGoodsTypeSelect:0
			showTargetLocationSelect:0
			showPostTimeSelect:0
			showInvoiceSelect:0
		}

	goodsTypeCkick: ->
		newState = Object.create @state
		if @state.showGoodsTypeSelect is 1 then newState.showGoodsTypeSelect = 0 else newState.showGoodsTypeSelect = 1
		@setState newState

	targetLocationCkick: ->
		newState = Object.create @state
		if @state.showTargetLocationSelect is 1 then newState.showTargetLocationSelect = 0 else newState.showTargetLocationSelect = 1
		@setState newState

	postTimeCkick:->
		newState = Object.create @state
		if @state.showPostTimeSelect is 1 then newState.showPostTimeSelect = 0 else newState.showPostTimeSelect = 1
		@setState newState

	invoiceCkick:->
		newState = Object.create @state
		if @state.showInvoiceSelect is 1 then newState.showInvoiceSelect = 0 else newState.showInvoiceSelect = 1
		@setState newState


	render: ->
		<div>
			<div className="m-nav03">
				<ul>
					{
						for s, i in selectionList
							<Selection selectionMap=s  key={i} />
					}
				</ul>			
			</div>

			<SearchResultList list={ @state.searchResult } />
		</div>
}

React.render <WarehouseSearchGoods />, document.getElementById('content')

