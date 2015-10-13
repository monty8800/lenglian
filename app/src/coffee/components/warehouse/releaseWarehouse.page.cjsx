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

ToReleaseWarehouseList = React.createClass {
	goToDetail: (index)->
		DB.put 'transData', @state.warehouseList[index].id
		Plugin.nav.push ['warehouseDetail']

	sureToRelease:(index, e)->
		WarehouseAction.releaseWarehouse @state.warehouseList[index].id
		e.stopPropagation()

	mixins : [PureRenderMixin]
	getInitialState: ->
		{
			warehouseList:[]
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.getWarehouseList '1','1','10'	#发布的 只显示空闲中的仓库

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark is 'getMyWarehouseList'		
			@setState { 
				warehouseList:WarehouseStore.getWarehouseList()
			}	
		else if mark is 'warehouseReleaseSucc'
			WarehouseAction.getWarehouseList '1','1','10'
		

	render: ->
		list = @state.warehouseList
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
					<a onClick={ @sureToRelease.bind this, i } class="u-release-btn">发布</a>
				</div>
			</div>
		, this
		<div>
			{items}
		</div>
}

React.render <ToReleaseWarehouseList />, document.getElementById('content')

