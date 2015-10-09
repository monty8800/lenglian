require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

Plugin = require 'util/plugin'

pageNow = '1'

pageSize = '10'

showType = '1' 		# 1-空闲中  2-已发布 3-使用中


WarehouseItem = React.createClass {
	goToDetail: (index)->
		DB.put 'transData', {warehouseId:@props.list[index].id,isMine:1}
		Plugin.nav.push ['warehouseDetail']

	render: ->
		list = @props.list
		items = list.map (aWarehouse,i) ->
			<div className="m-store" onClick={ @goToDetail.bind this, i }>
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
				</div>
			</div>
		, this
		<div>
			{items}
		</div>
}

WarehouseList = React.createClass {
	mixins : [PureRenderMixin]

	_topTypeClick : (index)->
		if index is @state.showType
			return
		newState = Object.create @state
		newState.showType = index
		newState.warehouseList = []
		@setState newState
		WarehouseAction.getWarehouseList index,'1','10'

	getInitialState: ->
		{
			warehouseList:[]
			showType:'1'
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.getWarehouseList '1','1','10'

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark is 'getMyWarehouseList'		
			@setState { 
				warehouseList:WarehouseStore.getWarehouseList()
				showType:WarehouseStore.getShowType()
			}	

	render: ->
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={ @_topTypeClick.bind this,'1' }>
						<span className={ if @state.showType == '1' then "active" else "" }>
							空闲中
						</span>
					</li>
					<li onClick={ @_topTypeClick.bind this,'2' }>
						<span className={ if @state.showType == '2' then "active" else "" }>
							已发布
						</span>
					</li>
					<li onClick={ @_topTypeClick.bind this,'3' }>
						<span className={ if @state.showType == '3' then "active" else "" }>
							使用中
					</span>
					</li>
				</ul>
			</div>
			<WarehouseItem list={ @state.warehouseList }/>
		</div>
		
}

React.render <WarehouseList />, document.getElementById('content')

