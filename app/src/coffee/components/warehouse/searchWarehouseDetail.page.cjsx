require 'components/common/common'
require 'user-center-style'
require 'majia-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'
Helper = require 'util/helper'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'
Plugin = require 'util/plugin'
XeImage = require 'components/common/xeImage'

_transData = DB.get('transData')
_isMine = _transData.isMine is 1


warehouseStatus = '' #状态
warehouseType = []	#类型
warehousePrice = [] #价格
warehouseIncreaseValue = [] #增值服务
warehouseArea = [] #面积

conf = (aProperty) ->
	switch aProperty.type
		when '1' then warehouseType.push aProperty.attributeName
		when '2' then warehouseIncreaseValue.push aProperty.attributeName
		when '3' then warehouseArea.push aProperty.attributeName + '   ' + aProperty.value
		when '4' then warehousePrice.push  aProperty.value + aProperty.attributeName

WarehouseDetail = React.createClass {
	getInitialState: ->
		{
			warehouseDetail:{}
			isFallow:false
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.getSearchWarehouseDetail _transData.warehouseId,_transData.focusid

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange
 
	_onChange: (mark) ->
		if mark is 'getSearchWarehouseDetailSucc'
			detailResult = WarehouseStore.getSearchWarehouseDetail()
			conf aProperty for aProperty in detailResult.warehouseProperty
			newState = Object.create @state
			newState.warehouseDetail = detailResult
			newState.isFallow = detailResult.wishlst
			@setState newState
		else if mark is 'fallowOrUnFallowHandleSucc'
			newState = Object.create @state
			newState.isFallow = !@state.isFallow
			@setState newState


	_fallowButtonClick:->
		#       (1)focusid 		(2)focustype 关注类型 1:司机 2：货主 3：仓库		(3) 2取消 1添加
		type = if @state.isFallow then 2 else 1
		WarehouseAction.handleFallow _transData.focusid,3,type
		

	render: ->
		<div>
			<div style={{display: if _transData?.orderId then 'block' else 'none'}} className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>{ _transData?.orderId }</span></p>
				<p className="fr">{ _transData?.orderStatus }</p>
			</div>
			<div style={{display: if _isMine then 'none' else 'block'}} className="m-item01">
				<div className="g-detail-dirver g-det-pad0">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<XeImage src={ @state.warehouseDetail.userHeaderImageUrl } size='100x100' type='avatar'/>
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ @state.warehouseDetail.userName }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper @state.warehouseDetail.certification }</span>
							</div>
							<div className="g-dirver-dis ll-font" dangerouslySetInnerHTML={{__html: Helper.stars @state.warehouseDetail.score}}/>
						</div>
						<ul className="g-driver-contact" onClick={ @_fallowButtonClick }>
							<li className={ if @state.isFallow then "ll-font" else "ll-font active" } >关注</li>
						</ul>
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="m-ck-adress">
					<h3>{ @state.warehouseDetail.name }	</h3>
					<p>地址：{ 
						detailAddr = @state.warehouseDetail
						if detailAddr.provinceName is detailAddr.cityName
							detailAddr.provinceName + detailAddr.areaName + detailAddr.street 
						else
							detailAddr.provinceName + detailAddr.cityName + detailAddr.areaName + detailAddr.street 
					}</p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<XeImage src={ @state.warehouseDetail.imageUrl } size='100x100'/>
					</div>
					<div className="g-pro-text fl">
						<p>仓库状态: <span>{ Helper.warehouseStatus @state.warehouseDetail.status }</span></p>
						<p>货物规格: <span>我是死数据，请修复我</span><span>常温 1000平方</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>增值服务:</span>
					<span>{ warehouseIncreaseValue.join ' ' }</span>
				</p>
				<p>
					<span>联系人:</span>
					<span>{ @state.warehouseDetail.contact }</span>
				</p>
				<p>
					<span>联系电话:</span>
					<span>{ @state.warehouseDetail.contactTel }</span>
				</p>	
				<p>
					<span>仓库价格:</span>
					<span>{ warehousePrice.join ' ' }</span>
				</p>	
				<p>
					<span>发票:</span>
					<span>{ Helper.invoiceStatus @state.warehouseDetail.invoice}</span>
				</p>	
				<p>
					<span>备注说明:</span>
					<span>{ @state.warehouseDetail.remark }</span>
				</p>				
			</div>
		
		</div>
}


React.render <WarehouseDetail />, document.getElementById('content')

