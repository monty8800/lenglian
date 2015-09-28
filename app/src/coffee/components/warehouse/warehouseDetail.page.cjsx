require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'
Helper = require 'util/helper'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'


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
		when '3' then warehouseArea.push aProperty.value + aProperty.attributeName
		when '4' then warehousePrice.push  aProperty.value + aProperty.attributeName

WarehouseDetail = React.createClass {
	getInitialState: -> {
		warehouseDetail:{}
	}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.getDetail(_warehouseId)

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange: ->
		detailResult = WarehouseStore.getDetail()
		conf aProperty for aProperty in detailResult.warehouseProperty
		@setState { 
			warehouseDetail:detailResult
		}

	render : ->
		<div>
			<div className="m-releaseitem">
				<div>
					<span>租赁时间</span><span>2015-10-29</span><span>10:00</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<span>仓库状态</span><span>500立方米</span><span>空闲中</span>
				</div>
				<div>
					<span>仓库价格</span><span>1000/天/平</span>
				</div>
				<div>
					<span>仓库类型</span><span>驶入式</span>
				</div>
				<div className="g-releaseDl">				
					<dl className="clearfix">
						<dt className="fl"><span>仓库面积</span></dt>
						<dd className="fl">
							<p>
								<u>常温</u> <label>1000立方米</label>
							</p>
							<p>
								<label>冷藏</label> <label>1000立方米</label>
							</p>					
						</dd>
					</dl>				
				</div>			
				<div>
					<span>仓库地址</span><span>海淀区中关村海淀北二街10号</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<span>发票</span><span>提供发票</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<span>增值服务</span><span>城配</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<span>联系人</span><span>李鑫萍</span>
				</div>
				<div>
					<span>手机号</span><span>13412356854</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<span>备注说明</span><span>联系时说明在冷链马甲看到的！</span>
				</div>
			</div>
		</div>
}






React.render <WarehouseDetail />,document.getElementById('content')
