require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'
Helper = require 'util/helper'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

Test = React.createClass {
	render :->
		<div>
			<div className="m-releasehead ll-font">
				<div className="g-adr-end ll-font g-adr-end-line">
					<input type="type" placeholder="输入终点"/>
				</div>
				<div className="g-adr-pass ll-font g-adr-pass-line">
					<input type="type" placeholder="北京海淀区中关村泰鹏大厦"/>
				</div>
				<div className="g-adr-middle ll-font">
					<input type="type" placeholder="途径地"/>
				</div>
				<div className="g-adr-start ll-font g-adr-start-line">
					<input type="type" placeholder="输入起点"/>
				</div>
				<a href="#" className="u-addIcon"></a>
			</div>
			<div className="m-releaseitem">
				<div className="u-arrow-right ll-font">
					<span>货物类型</span>
					<i className="arrow-i">24小时之后</i>
					<select className="select" name="">
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
					</select>
				</div>
				<div>
					<label for="proName"><span>货物名称</span></label>
					<input type="text" placeholder="选填" id="proName"/>
				</div>
				<div>
					<span>货物重量</span>
					<input type="text" className="weight"/><span>吨</span>
					<input type="text"  className="weight"/><span>千克</span>
				</div>
				<div>
					<label for="packType"><span>包装类型</span></label>
					<input type="text" placeholder="选填" id="packType"/>
				</div>
				<div className="choicePic">
					<span>货物照片</span> <i>选填</i>
					<figure>
						<span className="ll-font"></span>
					</figure>
					<input type="file" accept="image/*"/>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-arrow-right ll-font">
					<span>装车时间</span> <i>选填</i>
				</div>
				<div className="u-arrow-right ll-font">
					<span>货到时间</span> <i>选填</i>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="g-radio">
					<span>使用冷库</span>
					<div className="radio-box">
						<label className="mr5">
	                        <input className="mui-checkbox ll-font" name="xe-checkbox" type="radio"/>否
	                    </label>
	                    <label className="mr5">
	                        <input className="mui-checkbox ll-font" name="xe-checkbox" type="radio"/>是
	                    </label>
	                    <label className="mr5">
	                        <input className="mui-checkbox ll-font" name="xe-checkbox" type="radio"/>发地
	                    </label>
	                    <label className="mr5">
	                        <input className="mui-checkbox ll-font" name="xe-checkbox" type="radio"/>终点
	                    </label>
					</div>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="g-releaseDl">
					<dl className="clearfix">
						<dt className="fl"><span>价格类型</span></dt>
						<dd className="fl">
							<div>
								<label>
			                        <input className="mui-checkbox ll-font" name="xe-checkbox01" type="radio"/>一口价
			                    </label>
							</div>
							<div>
								<label>
			                        <input className="mui-checkbox ll-font" name="xe-checkbox01" type="radio"/>竞价
			                    </label>
								<input type="text" placeholder="请输入基础价" className="price"/>
							</div>					
						</dd>
					</dl>
				</div>	
				
			</div>
			<div className="m-releaseitem">
				<div className="g-releaseDl">
					<dl className="clearfix">
						<dt className="fl"><span>支付方式</span></dt>
						<dd className="fl">
							<div>
								<label>
			                        <input className="mui-checkbox ll-font" name="xe-checkbox02" type="radio"/>货到付款
			                    </label>
							</div>
							<div>
								<label>
			                        <input className="mui-checkbox ll-font" name="xe-checkbox02" type="radio"/>回单付款
			                    </label>
							</div>
							<div>
								<label>
			                        <input className="mui-checkbox ll-font" name="xe-checkbox02" type="radio"/>预付款
			                    </label>
								<input type="text" placeholder="请输入预付款" className="price"/>
							</div>						
						</dd>
					</dl>
				</div>	
			</div>
			<div className="m-releaseitem">
				<div className="g-radio">
					<span>需要发票</span>
					<div className="radio-box">
						<label className="mr5">
	                        <input className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/>否
	                    </label>
						<label className="mr5">
	                        <input className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/>是
	                    </label>
					</div>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>发货人</span><span>柠静</span>
				</div>
				<div>
					<span>手机号</span><span>13412356854</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>收货人</span><span>柠静</span>
				</div>
				<div>
					<span>手机号</span><span>13412356854</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-voice ll-font">
					<label for="remark"><span>备注说明</span> </label>
					<input type="text" placeholder="请输入备注消息" id="remark"/>
				</div>
			</div>
						
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a href="#" className="btn">发布</a>
				</div>
			</div>
		</div>
}

React.render <Test />,document.getElementById('content')



# _warehouseId = DB.get('transData')
# warehouseStatus = '' #状态
# warehouseType = []		#类型
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
# 	deleteWarehouse: ->
# 		alert 'delete warehouse'
# 	getInitialState: ->
# 		{
# 			warehouseDetail:{}
# 		}
# 	componentDidMount: ->
# 		WarehouseStore.addChangeListener @_onChange
# 		WarehouseAction.getDetail(_warehouseId)

# 	componentWillUnmount: ->
# 		WarehouseStore.removeChangeListener @_onChange

# 	_onChange: ->
# 		console.log '~~~~  ~~~  result data + ' + WarehouseStore.getDetail()
# 		detailResult = WarehouseStore.getDetail()
# 		conf aProperty for aProperty in detailResult.warehouseProperty
# 		@setState { 
# 			warehouseDetail:detailResult
# 		}
# 	render :->
# 		<div>
# 			<div className="m-item03">
# 				<div className="g-itemList">
# 					<h5>
# 						{ @state.warehouseDetail.name }				
# 					</h5>		
# 				</div>			
# 				<div className="g-itemList">
# 					<dl className="clearfix">
# 						<dt className=" fl">
# 							<img src="../images/product-01.jpg"/>
# 						</dt>
# 						<dd className=" fl">
# 							<p>仓库状态: 
# 								<span>{ Helper.warehouseStatus @state.warehouseDetail.status }</span>
# 							</p>
# 							<p>仓库类型: 
# 								<span>{ warehouseType.join ' ' }</span>
# 							</p>
# 							<p>仓库价格: 
# 								<span>{ warehousePrice.join ' ' }</span>
# 							</p>
# 							<p>增值服务: 
# 								<span>{ warehouseIncreaseValue.join ' ' }</span>
# 							</p>
# 						</dd>
# 					</dl>			
# 				</div>
# 			</div>
# 			<div className="m-detail-info m-nomargin">			
# 				<p>
# 					<span>仓库面积:</span>
# 					<span>{ warehouseArea.join '/' }</span>
# 				</p>
# 				<p>
# 					<span>仓库地址:</span>
# 					<span>{
# 						detailAddr = @state.warehouseDetail
# 						if detailAddr.provinceName is detailAddr.cityName
# 							detailAddr.provinceName + detailAddr.areaName + detailAddr.street 
# 						else
# 							detailAddr.provinceName + detailAddr.cityName + detailAddr.areaName + detailAddr.street 
# 					}</span>
# 				</p>		
# 			</div>
# 			<div className="m-detail-info m-nomargin">			
# 				<p>
# 					<span>发票:</span>
# 					<span>{ Helper.invoiceStatus @state.warehouseDetail.invoice }</span>
# 				</p>		
# 			</div>
# 			<div className="m-detail-info">			
# 				<p>
# 					<span>联系人:</span>
# 					<span>{ @state.warehouseDetail.contact }</span>
# 				</p>
# 				<p>
# 					<span>联系手机:</span>
# 					<span>{ @state.warehouseDetail.contactTel }</span>
# 				</p>
# 				<p>
# 					<span>备注说明:</span>
# 					<span>{ @state.warehouseDetail.remark }</span>
# 				</p>		
# 			</div>
# 			<div className="m-detail-bottom">
# 				<div className="g-pay-btn">
# 					<a onClick={ @deleteWarehouse } className="u-btn02">删除仓库</a>
# 				</div>
# 			</div>
# 		</div>
# }

# React.render <WarehouseDetail />, document.getElementById('content')
