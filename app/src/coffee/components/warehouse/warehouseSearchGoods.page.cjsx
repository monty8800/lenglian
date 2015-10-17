require 'components/common/common'
require 'index-style'
require 'majia-style'
require 'user-center-style'

XeImage = require 'components/common/xeImage'
Helper = require 'util/helper'
React = require 'react/addons'
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

SearchResultList = React.createClass {
	_resultItemClick:(aResult)->
		Auth.needLogin ->
			DB.put 'transData',{goodsId:aResult.id,focusid:aResult.userId}
			Plugin.nav.push ['searchGoodsDetail']

	_bindGoodsCreateOrder:(aResult)->
		console.log 'select ', aResult
		Auth.needLogin ->
			user = UserStore.getUser()
			if user.warehouseStatus is 1
				# if @state.userGoodsSource.length < 1
				# 	Plugin.toast.show '没有货源适合这个仓库'
				# 	return

#TODO:仓库找货  在弹出我的仓库列表的弹窗前 先判断有没有仓库

				_selectedGoodsId = aResult.id
				console.log _selectedGoodsId,'____仓库找货 货源ID_'
				# # GoodsAction.getGoodsList '0','10','1'		#1 求库中的货源
				Plugin.run [3, 'select:warehouse', _selectedGoodsId]
			else 
				Plugin.toast.err '尚未通过仓库主认证，请认证后再试'
		e.stopPropagation()

	render: ->
		resultList = @props.list
		items = resultList.map (aResult,i) ->
			<div className="m-item01 m-item03" onClick={ @_resultItemClick.bind this,aResult } >
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<XeImage src={ aResult.userImgUrl } size='100x100' type='avatar' />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ aResult.userName }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper aResult.certificAtion }</span>
							</div>
							<div className="g-dirver-dis ll-font">
								<Raty score={aResult.goodsScore} />
							</div>
						</div>
						<div className="g-dirver-btn">
							<a onClick={ @_bindGoodsCreateOrder.bind this, aResult } className="u-btn03">抢单</a>
						</div>
					</div>
				</div>
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
				<div className="g-item g-pad ll-font">
					<p dangerouslySetInnerHTML={{__html:'价格类型 : ' + Helper.priceTypeMapper aResult.priceType }} /> 
				</div>
				<div className="g-item g-item-des">
					<p>货物名称 : <span>{ aResult.name }</span></p>
					<p>货物类型 : <span>{ Helper.goodsType aResult.goodsType }</span><span>{aResult.weight + '吨'}</span><span>{ if aResult.cube then aResult.cube + '方'}</span></p>
					<p>装货时间 : <span>{ Moment(aResult.installStime).format('YYYY-MM-DD') }</span></p>
				</div>
			</div>
		,this
		<div>
			{items}
		</div>
}

WarehouseSearchGoods = React.createClass {

	_doWarehouseSearchGoods:->
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
			startNo: @state.startNo
			pageSize: @state.pageSize
			goodsType: @state.goodsType
			isInvoice: @state.isInvoice[0] if @state.isInvoice.length is 1 
			beginTime: beginTimestamp
			endTime: if parseInt(beginTimestamp) > 0 then currentTimestamp else ''
		}
		# # alert Moment().unix();
		# endTime:Math.round(new Date().getTime()/1000)
	getInitialState: ->
		initState = {
			searchResult:[]
			resultCount:-1
			startNo: 0
			pageSize: 100
		}

		for selection in selectionList
			initState[selection.key] = ''	#(option.key for option in selection.options)
		console.log 'initState', initState
		return initState


	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		SelectionStore.addChangeListener @_onChange
		@_doWarehouseSearchGoods()

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange
		SelectionStore.removeChangeListener @_onChange
		
	_onChange:(msg) ->
		console.log 'event change (((()))))', msg
		if msg.type
			newState = Object.create @state
			newState[msg.type] = msg.list
			console.log 'newState', newState
			@setState newState
		else if msg is 'do:warehouse:search:goods'
			@_doWarehouseSearchGoods()
		else if msg is 'warehouseSearchGoodsSucc'
			newState = Object.create @state
			newState.searchResult = WarehouseStore.getWarehouseSearchGoodsResult()
			newState.resultCount = newState.searchResult.length
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
			<div style={{display: if @state.resultCount is 0 then 'block' else 'none'}} className="m-searchNoresult">
				<div className="g-bgPic"></div>
				<p className="g-txt">很抱歉，没能找到您要的结果</p>
			</div>
			<SearchResultList list={ @state.searchResult } />
		</div>
}

React.render <WarehouseSearchGoods />, document.getElementById('content')

