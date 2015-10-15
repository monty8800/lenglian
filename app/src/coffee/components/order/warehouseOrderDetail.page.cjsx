require 'components/common/common'

require 'majia-style'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
Helper = require 'util/helper'
DB = require 'util/storage' 
UserStore = require 'stores/user/user'
OrderStore = require 'stores/order/order'
OrderAction = require 'actions/order/order'
XeImage = require 'components/common/xeImage'
Moment = require 'moment'
Raty = require 'components/common/raty'
_transData = DB.get 'transData'


WarehouseOrderDetail = React.createClass {
	minxins : [PureRenderMixin,LinkedStateMixin]
	componentDidMount: ->			
		OrderStore.addChangeListener @_onChange
		OrderAction.getWarehouseOrderDetail {orderNo:_transData?.orderNo,userId:UserStore.getUser()?.id,focusid:_transData?.goodsPersonUserId}

	componentWillNotMount: ->
		OrderStore.removeChangeListener @_onChange

	getInitialState:->
		{
			orderDetail:{}
			wishlst:false
			data:{}
		}

	_onChange: (mark)->
		if mark.msg is 'warehouse:order:detail:done'
			console.log '++++___+++ ',mark.detail
			newState = Object.create @state
			newState.orderDetail = mark.detail?.mjWarhousefoundGoods
			newState.data = mark.detail
			newState.wishlst = mark.detail.wishlst
			@setState newState
		else if mark[0] is 'attention_success'
			console.log '---attention_success-'
			newState = Object.create @state
			newState.wishlst = true
			@setState newState
		else if mark[0] is 'nattention_success'
			console.log '---nattention_success-'
			newState = Object.create @state
			newState.wishlst = false
			@setState newState
		else if mark[0] is 'warehouse:cancle:order:done'
			console.log 'cancle order succ'
			Plugin.nav.pop()

	_handleFallow: ()->
		type = ''
		if @state.wishlst
			type = 2 # 关注 则取消关注
		else
			type = 1 # 未关注 则添加关注
		OrderAction.attention({
			focusid: @state.orderDetail?.goodsPersonUserId 
			focustype: '1'
			userId: UserStore.getUser()?.id
			type: type
		})

	_cancleOrder: (index)->
		OrderAction.warehouseCancleOrder {
			orderNo:@state.orderDetail.orderNo
			warehousePersonUserId:@state.orderDetail.warehousePersonUserId
			version:@state.orderDetail.version
		}


	render: ->
		switch parseInt(@state.orderDetail?.orderState)
			when 1
				if @state.orderDetail?.orderType is 'GW'
					title = '等待仓库确认'
				else if @state.orderDetail?.orderType is 'WG'
					title = '等待货主确认'
			when 2
				if parseInt(@state.orderDetail?.payType) is 3
					title = '等待货主付款'
				else
					title = '货物存储中'
			when 3
				title = '货物存储中'

			when 4
				title = '待评价'

		
		<div>
			<div className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>{ _transData?.orderNo }</span></p>
				<p className="fr">{ title }</p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<XeImage src={ @state.orderDetail.goodsPersonHeadPic } size='100x100' type='avatar' />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ @state.orderDetail.goodsPersonName }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper @state.orderDetail.goodsPersonAuthMode}</span>
							</div>
							<div className="g-dirver-dis ll-font">
								{
									# @state.orderDetail.goodsPersonScore
									<Raty score={ @state.data.goodsScore } />
								}
							</div>
						</div>
						<ul className="g-driver-contact">
							<li onClick={ @_handleFallow } className={ if @state.wishlst then "ll-font" else 'll-font active'}>关注</li>
							<li className="ll-font">拨号</li>
						</ul>
					</div>
				</div>
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-store ll-font">
						{ @state.orderDetail.warehousePlace }
						<p>
							<span>{ Moment(@state.orderDetail.goodsCreateTime ).format('YYYY-MM-DD') }</span> 至 <span>2015-10-1</span>
						</p>
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">货物名称: <span>{ @state.orderDetail.goodsName }</span></p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<XeImage src={ @state.orderDetail.goodsPic } size='100x100' />
					</div>
					<div className="g-pro-text fl">
						<p>货物类型: <span>{ @state.orderDetail.goodsType }</span></p>
						<p>货物规格: <span>{ @state.orderDetail.goodsWeight }</span></p>
						<p>包装类型: <span>{ @state.orderDetail.goodsPackingType }</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>发货人:</span>
					<span className="ll-font g-info-name">{ @state.orderDetail.shipper }</span>
				</p>
				<p>
					<span>收货人:</span>
					<span className="ll-font g-info-name">{ @state.orderDetail.receiver }</span>
				</p>
				<p>
					<span>价格类型:</span>
					<span>{ Helper.priceTypeMapper @state.orderDetail.priceType }</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>{ Helper.payTypeMapper @state.orderDetail.payType }</span>
				</p>
				<p>
					<span>发票:</span>
					<span>{ Helper.isInvoinceMap @state.orderDetail.isInvoice }</span>
				</p>
				<p>
					<span>发布时间:</span>
					<span>{ Moment(@state.orderDetail.goodsCreateTime ).format('YYYY-MM-DD') }</span>
				</p>			
			</div>
			{
				if parseInt(@state.orderDetail?.orderState) is 1
					# 洽谈中的可以取消
					<div className="m-detail-bottom">
						<div onClick={@_cancleOrder} className="g-pay-btn">
							<a className="u-btn02">取消</a>
						</div>
					</div>
			}

		</div>
}



React.render <WarehouseOrderDetail />,document.getElementById('content')



