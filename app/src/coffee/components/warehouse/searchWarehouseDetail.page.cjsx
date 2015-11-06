require 'components/common/common'
require 'user-center-style'
require 'majia-style'
require 'index-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'
Helper = require 'util/helper'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'
Plugin = require 'util/plugin'
XeImage = require 'components/common/xeImage'
Raty = require 'components/common/raty'
_transData = DB.get('transData')
_isMine = _transData.isMine is 1

_user = UserStore.getUser()

warehouseStatus = '' #状态
warehouseType = []	#类型
warehousePrice = [] #价格
warehouseIncreaseValue = [] #配套服务
warehouseArea = [] #面积

conf = (aProperty) ->
	switch aProperty.type
		when '1'
			warehouseType.push aProperty.attributeName
		when '2' 
			warehouseIncreaseValue.push aProperty.attributeName
		when '3' 
			value = aProperty.attributeName + '   '
			if aProperty.value
				value = value + aProperty.value + '平方米'
			if aProperty.valueTwo
				value = value + (if aProperty.value then ' ' else '') + aProperty.valueTwo + '立方米'
			warehouseArea.push value
			# warehouseArea.push aProperty.attributeName + '   ' + aProperty.value
		when '4' 
			warehousePrice.push  aProperty.value + aProperty.attributeName

WarehouseDetail = React.createClass {
	getInitialState: ->
		{
			warehouseDetail:{}
			isFallow:false
			hideFallow:true
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
			newState.hideFallow = detailResult?.userId is _user.id
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
		tempratureArea = warehouseArea.map (aArea,i)->
			<p>{aArea}</p>
		, this
		phoneNum = ''
		if parseInt(_user.certification) is 0 
			phoneNum = '认证后可见'
		else
			phoneNum = @state.warehouseDetail.contactTel
		<div>
			<div style={{display: if _transData?.orderId then 'block' else 'none'}} className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>{ _transData?.orderId }</span></p>
				<p className="fr">{ _transData?.orderStatus }</p>
			</div>
			<div style={{display: if _isMine then 'none' else 'block'}} className="m-item01">
				<div className="g-detail-dirver g-det-pad0">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<XeImage src={ @state.warehouseDetail.userHeaderImageUrl } size='130x130' type='avatar'/>
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ @state.warehouseDetail.userName }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper @state.warehouseDetail.certification }</span>
							</div>
							<div className="g-dirver-dis ll-font">
								<Raty score={@state.warehouseDetail.score}/>
							 </div>
						</div>
						<ul style={{ display: if @state.hideFallow then 'none' else 'block' }} className="g-driver-contact" onClick={ @_fallowButtonClick }>
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
						if detailAddr
							if detailAddr.provinceName is detailAddr.cityName
								detailAddr.provinceName + detailAddr.areaName + detailAddr.street 
							else
								detailAddr.provinceName + detailAddr.cityName + detailAddr.areaName + detailAddr.street 
					}</p>
				</div>
				<div className="g-pro-detail clearfix">
					<div className="g-pro-pic fl">
						<XeImage src={ @state.warehouseDetail.imageUrl } size='200x200'/>
					</div>
					<div className="g-pro-text fl">
						<p>仓库状态: <span>{ Helper.warehouseStatus @state.warehouseDetail.status }</span></p>
						<p>仓库类型: <span>{ warehouseType.join ',' }</span></p>
						<p>仓库面积: { tempratureArea }</p>
					</div>
				</div>
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>配套服务:</span>
					<span>{ warehouseIncreaseValue.join ' ' }</span>
				</p>
				<p>
					<span>联系人:</span>
					<span>{ @state.warehouseDetail.contact }</span>
				</p>
				<p>
					<span>联系电话:</span>
					<span>{ phoneNum }</span>
				</p>	
				<p>
					<span>仓库价格:</span>
					<span>{ warehousePrice.join ' ' }</span>
				</p>	
				<p>
					<span>发票:</span>
					<span>{ Helper.invoiceStatus @state.warehouseDetail.invoice}</span>
				</p>	
				{
					if @state.warehouseDetail?.remark 
						<p>
							<span>备注:</span>
							<span>{ @state.warehouseDetail?.remark }</span>
						</p>
				}				
			</div>
		
		</div>
}


React.render <WarehouseDetail />, document.getElementById('content')

