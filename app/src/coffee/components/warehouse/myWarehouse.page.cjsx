require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
PureRenderMixin = React.addons.PureRenderMixin
InfiniteScroll = require('react-infinite-scroll')(React)
CSSTransitionGroup = React.addons.CSSTransitionGroup
DB = require 'util/storage'

Plugin = require 'util/plugin'

_pageNow = 1
_pageSize = 10
 		# 1-空闲中  2-已发布 3-使用中 showType = '1'

_hasMore = true
_isBusy = false
_isAfterRelease = false
_releaseIndex = -2
_leftWarehouseList = []

WarehouseList = React.createClass {
	mixins : [PureRenderMixin]

	_topTypeClick : (index)->
		if index is @state.showType
			return
		_hasMore = true
		_pageNow = 1
		newState = Object.create @state
		newState.showType = index
		newState.warehouseList = []
		@setState newState
		_isBusy = true
		WarehouseAction.getWarehouseList index,_pageNow,_pageSize

	_goToDetail: (index)->
		DB.put 'transData', { warehouseId:@state.warehouseList[index].id,isMine:1 }
		Plugin.nav.push ['warehouseDetail']

	getInitialState: ->
		{
			warehouseList:[]
			showType:'1'
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		_isBusy = true
		WarehouseAction.getWarehouseList '1',_pageNow,_pageSize

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark is 'getMyWarehouseList'	
			_isBusy = false	
			if _isAfterRelease
				_pageNow = 1
				_isAfterRelease = false
			_pageNow++
			warehouseList = WarehouseStore.getWarehouseList()
			_hasMore = warehouseList.length - @state.warehouseList.length is _pageSize
			newState = Object.create @state
			newState.showType = WarehouseStore.getShowType()
			newState.warehouseList = WarehouseStore.getWarehouseList()
			@setState newState
			console.log @state.warehouseList.length+ '++++++++++++++____________'
		else if mark is 'warehouseReleaseSucc'
			_isAfterRelease = true
			_leftWarehouseList = Object.create @state.warehouseList
			_leftWarehouseList.splice _releaseIndex,1
			@setState {
				warehouseList:_leftWarehouseList
			}

	_loadMore:()->
		if parseInt(_pageNow) > 1
			_isBusy = true
			WarehouseAction.getWarehouseList @state.showType,_pageNow,_pageSize

	_sureToRelease:(index, e)->
		_releaseIndex = index
		WarehouseAction.releaseWarehouse @state.warehouseList[index].id
		e.stopPropagation()


	render: ->
		items = @state.warehouseList.map (aWarehouse,i) ->
			console.log 'render go ________'
			<div className="m-store" onClick={ @_goToDetail.bind this, i }>
				<div>
					<p>{ aWarehouse.name }</p>
					<span>
						{ 
							if aWarehouse.provinceName is aWarehouse.cityName
								aWarehouse.provinceName + aWarehouse.areaName + aWarehouse.street 
							else
								aWarehouse.provinceName + aWarehouse.cityName + aWarehouse.areaName + aWarehouse.street 
						}
					</span>
					{
						if @state.showType is '1'
							<a onClick={ @_sureToRelease.bind this, i } class="u-release-btn">发布</a>
					}
				</div>
			</div>
		, this

		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={ @_topTypeClick.bind this,'1' }>
					{
						if parseInt(@state.showType) is 1
							<span className="active">空闲</span>
						else
							'空闲'
					}
					</li>
					<li onClick={ @_topTypeClick.bind this,'2' }>
					{
						if parseInt(@state.showType) is 2
							<span className="active">已发布</span>
						else
							'已发布'
					}
					</li>
					<li onClick={ @_topTypeClick.bind this,'3' }>
					{
						if parseInt(@state.showType) is 3
							<span className="active">使用中</span>
						else
							'使用中'
					}
					</li>
				</ul>
			</div>
			<div>
				<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={_hasMore and not _isBusy} >
					<CSSTransitionGroup transitionName="list">
						{items}
					</CSSTransitionGroup>
				</InfiniteScroll>
			</div>
		</div>
		
}

React.render <WarehouseList />, document.getElementById('content')

