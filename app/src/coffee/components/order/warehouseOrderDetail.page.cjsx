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
			mjRateflag:true
		}

	_onChange: (mark)->
		if mark.msg is 'warehouse:order:detail:done'
			console.log '++++___+++ ',mark.detail
			newState = Object.create @state
			newState.orderDetail = mark.detail?.mjWarhousefoundGoods
			newState.data = mark.detail
			newState.wishlst = mark.detail.wishlst
			newState.mjRateflag = newState.orderDetail.mjRateflag
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
		else if mark[0] is 'orderDetailCommentUpdate'
			@setState {
				mjRateflag: true
			}

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
		orderNo = @state.orderDetail.orderNo
		warehousePersonUserId = @state.orderDetail.warehousePersonUserId
		version = @state.orderDetail.version
		Plugin.alert '确认取消吗', '提示', (index)->
			if index is 1
				OrderAction.warehouseCancleOrder {
					orderNo:orderNo
					warehousePersonUserId:warehousePersonUserId
					version:version
				}
		, ['确定', '取消']


	_doComment:->
		if @state.mjRateflag
			Plugin.toast.show '评价过了'
		else
			DB.put 'transData', {
				userRole: '3'
				targetId: @state.orderDetail?.goodsPersonUserId
				targetRole: if @state.orderDetail?.orderType in ['GW', 'WG'] then 1 
				orderNo: @state.orderDetail?.orderNo
			}
			Plugin.nav.push ['doComment']
		

	_makePhoneCall:(phone)->
		if phone
			window.location.href = 'tel:' + phone

	render: ->
		switch parseInt(@state.orderDetail?.orderState)
			when 1
				if parseInt(@state.orderDetail?.warehouseSourceMode) is 1
					title = '等待货主确认'
				else if parseInt(@state.orderDetail?.warehouseSourceMode) is 2
					title = ''	
			when 2
				if parseInt(@state.orderDetail?.payType) is 3  	
					title = '等待货主付款'
				else
					title = '货物存储中'
			when 3
				title = '货物存储中'

			when 4
				if @state.mjRateflag
					title = '已评价'
				else
					title = '待评价'

		_payTypeText = Helper.payTypeMapper @state.orderDetail?.payType
		if parseInt(@state.orderDetail?.payType) is 3 and @state.orderDetail?.advance
			_payTypeText = _payTypeText + @state.orderDetail?.advance + '元'

		<div>
			<div className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>{ _transData?.orderNo }</span></p>
				<p className="fr">{ title }</p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<XeImage src={ @state.orderDetail.goodsPersonHeadPic } size='130x130' type='avatar' />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ @state.orderDetail.goodsPersonName }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper @state.orderDetail.goodsPersonAuthMode}</span>
							</div>
							<div className="g-dirver-dis ll-font">
								<Raty score={ @state.data.goodsScore } />
							</div>
						</div>
						<ul className="g-driver-contact">
							<li onClick={ @_handleFallow } className={ if @state.wishlst then "ll-font" else 'll-font active'}>关注</li>
							<li onClick={ @_makePhoneCall.bind this, @state.orderDetail.goodsPersonMobile } className="ll-font">拨号</li>
						</ul>
					</div>
				</div>
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-store ll-font">
						{ @state.orderDetail.warehousePlace }
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">货物名称: <span>{ @state.orderDetail.goodsName }</span></p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<XeImage src={ @state.orderDetail.goodsPic } size='200x200' />
					</div>
					<div className="g-pro-text fl">
						<p>货物类型: <span>{ @state.orderDetail.goodsType }</span></p>
						<p>货物规格: <span>{ if @state.orderDetail.goodsWeight then @state.orderDetail.goodsWeight + '吨' else ''}</span><span>{ if @state.orderDetail.goodsCubic then @state.orderDetail.goodsCubic + '方' else ''}</span></p>
						<p>包装类型: <span>{ @state.orderDetail.goodsPackingType }</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>发货人:</span>
					<span onClick={ @_makePhoneCall.bind this, @state.orderDetail.shipperMobile } className="ll-font g-info-name">{ @state.orderDetail.shipper }</span>
				</p>
				<p>
					<span>收货人:</span>
					<span onClick={ @_makePhoneCall.bind this, @state.orderDetail.receiverMobile } className="ll-font g-info-name">{ @state.orderDetail.receiver }</span>
				</p>
				<p>
					<span>价格类型:</span>
					<span>{ Helper.priceTypeMapper @state.orderDetail.priceType }  { if @state.orderDetail.price then @state.orderDetail.price + '元' else '' }</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>{ _payTypeText }</span>
				</p>
				<p>
					<span>发票:</span>
					<span>{ Helper.isInvoinceMap @state.orderDetail.isInvoice }</span>
				</p>
				<p>
					<span>发布时间:</span>
					<span>{ if @state.orderDetail.goodsCreateTime then Moment(@state.orderDetail.goodsCreateTime ).format('YYYY-MM-DD') else ''}</span>
				</p>			
			</div>
			{
				if parseInt(@state.orderDetail?.orderState) is 1 
					<div className="m-detail-bottom">
						<div onClick={@_cancleOrder} className="g-pay-btn">
							<a className="u-btn02">取消</a>
						</div>
					</div>
				else if parseInt(@state.orderDetail?.orderState) is 4 
					if not @state.mjRateflag
						<div className="m-detail-bottom">
							<div onClick={@_doComment} className="g-pay-btn">
								<a className="u-btn02">评价货主</a>
							</div>
						</div>

			}

		</div>
}



React.render <WarehouseOrderDetail />,document.getElementById('content')



