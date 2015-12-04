require 'components/common/common'
require 'index-style'
require 'majia-style'
require 'user-center-style'

XeImage = require 'components/common/xeImage'
Helper = require 'util/helper'
React = require 'react/addons'
CSSTransitionGroup = React.addons.CSSTransitionGroup
InfiniteScroll = require('react-infinite-scroll')(React)

Auth = require 'util/auth'
headerImg = require 'user-01.jpg'
WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
Moment = require 'moment'
Selection = require 'components/common/selection'
SelectionStore = require 'stores/common/selection'
UserStore = require 'stores/user/user'
Raty = require 'components/common/raty'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

Plugin = require 'util/plugin'

_selectedGoodsId = ''
_isBusy = false
_hasMore = true
_startNo = 0
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
		key: 'releaseTime'
		value: '发布时间'
		options: [
			{key: '1', value: '一天内'}
			{key: '2', value: '三天内'}
			{key: '3', value: '五天内'}
			{key: '4', value: '一周内'}
			{key: '5', value: '两周内'}
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


WarehouseSearchGoods = React.createClass {

	_doWarehouseSearchGoods:->
		_isBusy = true
		console.log 'do search warehouse - goods'
		currentTimestamp = Math.round(new Date().getTime()/1000)
		beginTimestamp = ''
		if @state.releaseTime.length > 0 and @state.releaseTime instanceof Array	
			tmp = @state.releaseTime
			max = parseInt tmp[0]
			for obj,i in tmp
				if max < parseInt tmp[i]
					max = parseInt tmp[i]
			switch max
				when 1 then beginTimestamp = currentTimestamp - 1 * 24 * 60 * 60
				when 2 then beginTimestamp = currentTimestamp - 3 * 24 * 60 * 60
				when 3 then beginTimestamp = currentTimestamp - 5 * 24 * 60 * 60
				when 4 then beginTimestamp = currentTimestamp - 7 * 24 * 60 * 60
				when 5 then beginTimestamp = currentTimestamp - 14 * 24 * 60 * 60


		WarehouseAction.warehouseSearchGoods {
			startNo: _startNo
			pageSize: @state.pageSize
			goodsType: @state.goodsType
			isInvoice: @state.isInvoice[0] if @state.isInvoice.length is 1 
			beginTime: beginTimestamp * 1000
			endTime: if parseInt(beginTimestamp) > 0 then currentTimestamp * 1000 else ''
		}

	_resultItemClick:(aResult)->
		Auth.needLogin ->
			DB.put 'transData',{goodsId:aResult.id, focusid:aResult.userId, flag: 'warehouse'}
			Plugin.nav.push ['searchGoodsDetail']

	_bindGoodsCreateOrder:(aResult,e)->
		console.log 'select ', aResult
		Auth.needLogin ->
			user = UserStore.getUser()
			if user.id is aResult.userId
				Plugin.toast.err '不能选择自己的货物'
			else
				Auth.needAuth 'warehouse',->
					_selectedGoodsId = aResult.id
					console.log _selectedGoodsId,'____仓库找货 货源ID_'
					# # GoodsAction.getGoodsList '0','10','1'		#1 求库中的货源
					Plugin.run [3, 'select:warehouse', _selectedGoodsId]
		e.stopPropagation()


	getInitialState: ->
		initState = {
			searchResult:[]
			showHasNone:false
			pageSize: 10
		}

		for selection in selectionList
			initState[selection.key] = ''	#(option.key for option in selection.options)
		return initState


	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		# SelectionStore.addChangeListener @_onChange
		@_doWarehouseSearchGoods()

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange
		# SelectionStore.removeChangeListener @_onChange
		
	_onChange:(msg) ->
		if msg.type in ['goodsType','releaseTime','isInvoice']
			newState = Object.create @state
			newState[msg.type] = msg.list
			console.log 'newState', newState
			@setState newState
		else if msg is 'do:warehouse:search:goods'
			newState = Object.create @state
			_startNo = 0
			_hasMore = true
			@setState newState
			@_doWarehouseSearchGoods()
		else if msg is 'warehouseSearchGoodsSucc'
			_isBusy = false
			newState = Object.create @state
			newState.searchResult = WarehouseStore.getWarehouseSearchGoodsResult()
			_hasMore = parseInt(newState.searchResult.length) - parseInt(_startNo) is parseInt(@state.pageSize)
			_startNo = newState.searchResult.length
			newState.showHasNone = newState.searchResult.length is 0
			@setState newState

	_search: ->
		newState = Object.create @state
		_startNo = 0
		_hasMore = true
		@setState newState
		@_doWarehouseSearchGoods()

	render: ->
		items = @state.searchResult.map (aResult,i) ->
			<div className="m-item01 m-item03" onClick={ @_resultItemClick.bind this,aResult } >
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<XeImage src={ aResult.userImgUrl } size='130x130' type='avatar' />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ aResult.userName }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper aResult.certificAtion }</span>
							</div>
							<div className="g-dirver-dis ll-font">
								<Raty score={aResult.userScore} />
							</div>
						</div>
						<div className="g-dirver-btn">
							<a onClick={ @_bindGoodsCreateOrder.bind this, aResult } className="u-btn03">抢单</a>
						</div>
					</div>
				</div>
				{
					switch parseInt(aResult.coldStoreFlag)
						when 2
							<div className="g-item">
								<div className="g-adr-end ll-font">
									<p dangerouslySetInnerHTML={{__html: 
										if aResult.fromProvinceName is aResult.fromCityName
											aResult.fromProvinceName + aResult.fromAreaName
										else
											aResult.fromProvinceName + aResult.fromCityName + aResult.fromAreaName
									}}/>
								</div>
								<div className="g-adr-start ll-font">
									<p dangerouslySetInnerHTML={{__html: 
										if aResult.toProvinceName is aResult.toCityName
											aResult.toProvinceName + aResult.toAreaName
										else
											aResult.toProvinceName + aResult.toCityName + aResult.toAreaName
									}}/>
								</div>
							</div>
						when 3
							<div className="g-item">
								<div className="g-adr-start ll-font">
									<p dangerouslySetInnerHTML={{__html: 
										if aResult.toProvinceName is aResult.toCityName
											aResult.toProvinceName + aResult.toAreaName
										else
											aResult.toProvinceName + aResult.toCityName + aResult.toAreaName
									}}/>
								</div>
							</div>
						when 4
							<div className="g-item">
								<div className="g-adr-end ll-font">
									<p dangerouslySetInnerHTML={{__html: 
										if aResult.fromProvinceName is aResult.fromCityName
											aResult.fromProvinceName + aResult.fromAreaName
										else
											aResult.fromProvinceName + aResult.fromCityName + aResult.fromAreaName
									}}/>
								</div>
							</div>

				}
				<div className="g-item g-pad ll-font">
					{
						if aResult.price
							<p dangerouslySetInnerHTML={{__html:'价格类型 : ' + (Helper.priceTypeMapper aResult.priceType) + aResult.price + '元' }} /> 
						else if condition
							 <p dangerouslySetInnerHTML={{__html:'价格类型 : ' + Helper.priceTypeMapper aResult.priceType}}/> 
					}
				</div>
				<div className="g-item g-item-des">
					<p>货物名称 : <span>{ aResult.name }</span></p>
					<p>货物类型 : <span>{ Helper.goodsType aResult.goodsType }</span><span>{if parseFloat(aResult.weight) > 0 then aResult.weight + '吨' else ''}</span><span>{ if parseFloat(aResult.cube) > 0 then aResult.cube + '方' else ''}</span></p>
					<p>装货时间 : <span>{ Moment(aResult.installStime).format('YYYY-MM-DD') }</span></p>
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
			<div onClick={@_search} className="u-pay-btn">
				<a className="btn">搜索</a>
			</div>
			<div style={{display: if @state.showHasNone then 'block' else 'none'}} className="m-searchNoresult">
				<div className="g-bgPic"></div>
				<p className="g-txt">很抱歉，没能找到您要的结果</p>
			</div>
			<InfiniteScroll pageStart=0 loadMore={@_doWarehouseSearchGoods} hasMore={_hasMore and not _isBusy}>
				<CSSTransitionGroup transitionName="list">
					{items}
				</CSSTransitionGroup>
			</InfiniteScroll>
		</div>
}

React.render <WarehouseSearchGoods />, document.getElementById('content')

# 