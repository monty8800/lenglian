require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'

PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'


_warehouseId = DB.get('transData')

WarehouseDetailTop = React.createClass {

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
		console.log '__ _result data + ' + WarehouseStore.getDetail()
		@setState { 
			warehouseDetail:WarehouseStore.getDetail()
		}

	render :->
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
							<p>仓库状态: <span>500立方米</span> <span>空闲中</span></p>
							<p>仓库类型: <span>驶入式</span></p>
							<p>仓库价格: <span>1000/天/托</span></p>
							<p>增值服务: <span>城配</span></p>
						</dd>
					</dl>			
				</div>
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>仓库面积:</span>
					<span>常温  1000立方米/冷藏  1000立方米</span>
				</p>
				<p>
					<span>仓库地址:</span>
					<span>海淀区中关村海淀北二街10号</span>
				</p>		
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>发票:</span>
					<span>可以开发票</span>
				</p>		
			</div>
			<div className="m-detail-info">			
				<p>
					<span>联系人:</span>
					<span>李鑫萍</span>
				</p>
				<p>
					<span>联系手机:</span>
					<span>18622568566</span>
				</p>
				<p>
					<span>备注说明:</span>
					<span>联系时请说明是在冷链马甲看到的！</span>
				</p>		
			</div>
			<div className="m-detail-bottom">
				<div className="g-pay-btn">
					<a href="#" className="u-btn02">删除仓库</a>
				</div>
			</div>
		</div>
}



WarehouseDetail = React.createClass {
	render : ->
		<div>
			<WarehouseDetailTop />
		</div>
}

React.render <WarehouseDetail />, document.getElementById('content')
