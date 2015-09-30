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
		console.log '######## $$$$$$ ' ,index
		DB.put 'transData', @props.list[index].id
		Plugin.nav.push ['warehouseDetail']

	render: ->
		list = @props.list
		console.log list + '++***&&&++'
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

	showNormalWarehouse: ->
		if @state.showType is '1'
			return
		newState = Object.create @state
		newState.showType = '1'
		newState.warehouseList = []
		@setState newState
		WarehouseAction.getWarehouseList '1','1','10'

	showSendingWarehouse: ->
		if @state.showType is '2'
			return
		newState = Object.create @state
		newState.showType = '2'
		newState.warehouseList = []
		@setState newState
		WarehouseAction.getWarehouseList '2','1','10'

	showUsingWarehouse: ->
		if @state.showType is '3'
			return
		newState = Object.create @state
		newState.showType = '3'
		newState.warehouseList = []
		@setState newState
		WarehouseAction.getWarehouseList '3','1','10'

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
					<li onClick={ @showNormalWarehouse }>
						<span className={ if @state.showType == '1' then "active" else "" }>
							空闲中
						</span>
					</li>
					<li onClick={ @showSendingWarehouse }>
						<span className={ if @state.showType == '2' then "active" else "" }>
							已发布
						</span>
					</li>
					<li onClick={ @showUsingWarehouse }>
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

