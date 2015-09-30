require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'
Helper = require 'util/helper'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'
Plugin = require 'util/plugin'

_warehouseId = DB.get('transData')
warehouseStatus = '' #状态
warehouseType = []		#类型
warehousePrice = [] #价格
warehouseIncreaseValue = [] #增值服务
warehouseArea = [] #面积

conf = (aProperty) ->

	switch aProperty.type
		when '1' then warehouseType.push aProperty.attributeName
		when '2' then warehouseIncreaseValue.push aProperty.attributeName
		when '3' then warehouseArea.push aProperty.attributeName + '   ' + aProperty.value
		when '4' then warehousePrice.push  aProperty.value + aProperty.attributeName

window.startEditWarehouse = ->


WarehouseDetail = React.createClass {
	deleteWarehouse: ->
		alert 'delete warehouse'
	getInitialState: ->
		{
			warehouseDetail:{}
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.getDetail(_warehouseId)

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange: ->
		console.log '~~~~  ~~~  result data + ' + WarehouseStore.getDetail()
		detailResult = WarehouseStore.getDetail()
		conf aProperty for aProperty in detailResult.warehouseProperty
		@setState { 
			warehouseDetail:detailResult
		}
	render :->
		warehouseAreaList = warehouseArea.map (aArea,i) ->
			<p>
				<span>{if i is 0 then "仓库面积:"}</span>
				<span>{ aArea }</span>
			</p>
		, this

		<div>
			<div className="m-item03">
				<div className="g-itemList">
					<h5>
						{ @state.warehouseDetail.name }				
					</h5>		
				</div>			
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<img src="../images/product-01.jpg"/>
						</dt>
						<dd className=" fl">
							<p>仓库状态: 
								<span>{ Helper.warehouseStatus @state.warehouseDetail.status }</span>
							</p>
							<p>仓库类型: 
								<span>{ warehouseType.join ' ' }</span>
							</p>
							<p>仓库价格: 
								<span>{ warehousePrice.join ' ' }</span>
							</p>
							<p>增值服务: 
								<span>{ warehouseIncreaseValue.join ' ' }</span>
							</p>
						</dd>
					</dl>			
				</div>
			</div>
			<div className="m-detail-info m-nomargin">			
				{ warehouseAreaList }
			</div>
			<div className="m-detail-info m-nomargin">
				<p>
					<span>仓库地址:</span>
					<span>{
						detailAddr = @state.warehouseDetail
						if detailAddr.provinceName is detailAddr.cityName
							detailAddr.provinceName + detailAddr.areaName + detailAddr.street 
						else
							detailAddr.provinceName + detailAddr.cityName + detailAddr.areaName + detailAddr.street 
					}</span>
				</p>		
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>发票:</span>
					<span>{ Helper.invoiceStatus @state.warehouseDetail.invoice }</span>
				</p>		
			</div>
			<div className="m-detail-info">			
				<p>
					<span>联系人:</span>
					<span>{ @state.warehouseDetail.contact }</span>
				</p>
				<p>
					<span>联系手机:</span>
					<span>{ @state.warehouseDetail.contactTel }</span>
				</p>
				<p>
					<span>备注说明:</span>
					<span>{ @state.warehouseDetail.remark }</span>
				</p>		
			</div>

			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span>
					<span>林夕</span>
				</div>
				<div>
					<span>联系手机</span>
					<span>13412356854</span>
				</div>
				<div className="u-voice ll-font">
					<label for="remark"><span>备注说明</span> </label>
					<input type="text" placeholder="选填" id="remark"/>
				</div>
			</div>
			
			<div className="m-detail-bottom">
				<div className="g-pay-btn">
					<a onClick={ @deleteWarehouse } className="u-btn02">删除仓库</a>
				</div>
			</div>
		</div>
}


React.render <WarehouseDetail />, document.getElementById('content')







# _warehouseId = DB.get('transData')
# warehouseStatus = '' #状态
# warehouseType = []	#类型
# warehousePrice = [] #价格
# warehouseIncreaseValue = [] #增值服务
# warehouseArea = [] #面积

# conf = (aProperty) ->
# 	switch aProperty.type
# 		when '1' then warehouseType.push aProperty.attributeName
# 		when '2' then warehouseIncreaseValue.push aProperty.attributeName
# 		when '3' then warehouseArea.push aProperty.value + aProperty.attributeName
# 		when '4' then warehousePrice.push  aProperty.value + aProperty.attributeName

# WarehouseDetail = React.createClass {
# 	getInitialState: -> {
# 		warehouseDetail:{}
# 	}
# 	componentDidMount: ->
# 		WarehouseStore.addChangeListener @_onChange
# 		WarehouseAction.getDetail(_warehouseId)

# 	componentWillUnmount: ->
# 		WarehouseStore.removeChangeListener @_onChange

# 	_onChange: (mark)->
# 		if mark is 'getDetailWithId'
# 			detailResult = WarehouseStore.getDetail()
# 			conf aProperty for aProperty in detailResult.warehouseProperty
# 			@setState { 
# 				warehouseDetail:detailResult
# 			}

# 	render : ->
# 		<div>
# 			<div className="m-releaseitem">
# 				<div>
# 					<span>租赁时间</span><span>{ @state.warehouseDetail.rentTime }</span><span>10:00</span>
# 				</div>
# 			</div>
# 			<div className="m-releaseitem">
# 				<div>
# 					<span>仓库状态</span><span>{ Helper.warehouseStatus @state.warehouseDetail.status }</span>
# 				</div>
# 				<div>
# 					<span>仓库价格</span><span>{ warehousePrice.join ' ' }</span>
# 				</div>
# 				<div>
# 					<span>仓库类型</span><span>{ warehouseType.join ' ' }</span>
# 				</div>
# 				<div className="g-releaseDl">				
# 					<dl className="clearfix">
# 						<dt className="fl"><span>仓库面积</span></dt>
# 						<dd className="fl">
# 							<p>
# 								<u>常温</u> <label>1000立方米</label>
# 							</p>
# 							<p>
# 								<label>冷藏</label> <label>1000立方米</label>
# 							</p>					
# 						</dd>
# 					</dl>				
# 				</div>			
# 				<div>
# 					<span>仓库地址</span><span>{
# 							aWarehouse = @state.warehouseDetail
# 							if aWarehouse.provinceName is aWarehouse.cityName
# 								aWarehouse.provinceName + aWarehouse.areaName + aWarehouse.street 
# 							else
# 								aWarehouse.provinceName + aWarehouse.cityName + aWarehouse.areaName + aWarehouse.street 
# 						}</span>
# 				</div>
# 			</div>
# 			<div className="m-releaseitem">
# 				<div>
# 					<span>发票</span><span>{
# 						if @state.warehouseDetail.invoice is '1' 
# 							"提供发票"
# 						else
# 							"不提供发票"
# 					}</span>
# 				</div>
# 			</div>
# 			<div className="m-releaseitem">
# 				<div>
# 					<span>增值服务</span><span>{ warehouseIncreaseValue.join ' '}</span>
# 				</div>
# 			</div>
# 			<div className="m-releaseitem">
# 				<div>
# 					<span>联系人</span><span>{ @state.warehouseDetail.contact }</span>
# 				</div>
# 				<div>
# 					<span>手机号</span><span>{ @state.warehouseDetail.contactTel }</span>
# 				</div>
# 			</div>
# 			<div className="m-releaseitem">
# 				<div>
# 					<span>备注说明</span><span>{ @state.warehouseDetail.remark }</span>
# 				</div>
# 			</div>
# 		</div>
# }



# React.render <WarehouseDetail />,document.getElementById('content')
