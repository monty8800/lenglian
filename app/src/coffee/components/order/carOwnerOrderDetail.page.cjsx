# 车主订单详情
require 'components/common/common'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
Plugin = require 'util/plugin'
Helper = require 'util/helper'
Constants = require 'constants/constants'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'
DRIVER_LOGO = require 'user-01.jpg'
DB = require 'util/storage'
UserStore = require 'stores/user/user'
XeImage = require 'components/common/xeImage'
avatar = require 'user-01'
Image = require 'util/image'
_user = UserStore.getUser()
title = null

OrderDetail = React.createClass {

	getInitialState: ->
		detail = DB.get 'car_owner_order_detail'
		{
			carPersonUserId: detail[0]
			orderNo: detail[1]
			goodsPersonUserId: detail[2]
			order: OrderStore.getOrderDetail()
			wishlst: false
		}

	componentDidMount: ->
		OrderAction.carOwnerOrderDetail(@state.carPersonUserId, @state.orderNo, @state.goodsPersonUserId)			
		OrderStore.addChangeListener @resultCallBack

# goodSsourceId
	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] is 'car_owner_order_detail'
			detail = OrderStore.getOrderDetail()
			newState = Object.create @state
			newState.order = detail
			newState.wishlst = detail.wishlst
			@setState newState
		else if params[0] is 'attention_success'
			console.log '---attention_success-'
			newState = Object.create @state
			newState.wishlst = true
			@setState newState
		else if params[0] is 'nattention_success'
			console.log '---nattention_success-'
			newState = Object.create @state
			newState.wishlst = false
			@setState newState

	attention: (flag, goodsPersonUserId)->
		type = ''
		if flag
			# 关注
			type = 2
		else
			# 取消关注
			type = 1
		OrderAction.attention({
			focusid: goodsPersonUserId
			focustype: '1'
			userId: _user?.id
			type: type
		})

		# 车主详情
	_goPage: ->
		item = @state.order.toJS()
		console.log '-----item:', item
		id = item?.goodsSourceId
		focusid = item?.goodsPersonUserId
		console.log '-------id:', id
		console.log '-------focusid:', focusid
		DB.put 'transData', {
			goodsId: id
			focusid: focusid
			orderNo: item.orderNo
			orderStatus: title
		}
		Plugin.nav.push ['searchWarehouseDetail']


	_comment: (targetId, orderNo)->
		DB.put 'transData', {
			userRole: '2'
			targetId: targetId
			targetRole: '1'
			orderNo: orderNo
		}
		Plugin.nav.push ['doComment']

	render: ->
		if @state.order?.orderState is '1'
			if @state.order?.orderType is 'CG'
				title = '等待货主确认'
		else if @state.order?.orderState is '2'
			# 1：货到付款（线下）2：回单付款（线下） 3：预付款（线上）
			if @state.order?.payType is '3'
				title = '等待货主付款'
			else
				title = '货物运输中'
		else if @state.order?.orderState is '3'
			title = '货物运输中'
		else if @state.order?.orderState is '4'
			title = '待评价'

		<div>
			<div className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>{@state.order.orderNo}</span></p>
				<p className="fr">{title}</p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver">
					<div className="g-detail">					
						<div onClick={@_goPage} className="g-dirver-pic">
							<XeImage src={@state.order?.goodsPersonHeadPic} size='130x130' type='avatar' />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{@state.order.goodsPersonName}</span><span className="g-dirname-single">{Helper.whoYouAreMapper @state.order.certification}</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<ul className="g-driver-contact">
							<li className={ if @state.wishlst then "ll-font" else 'll-font active'} onClick={@attention.bind this, @state.wishlst, @state.order?.goodsPersonUserId}>关注</li>
							<li className="ll-font">拨号</li>
						</ul>
					</div>
				</div>
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-start ll-font g-adr-start-line">
						{@state.order.destination}
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						{@state.order.setOut}
					</div>	
				</div>
			</div>
			<div className="m-item01">
				<div className="g-detail-time01">
					<span className="fl">装货时间:</span>
					<span className="fr">
						{Helper.subStr 0, 10, @state.order?.loadingSdate} 到 {Helper.subStr 0, 10, @state.order?.loadingEdate}
					</span>
				</div>
				<div className="g-detail-time01">
					<span className="fl">到货时间:</span>
					<span className="fr">
						{Helper.subStr 0, 10, @state.order?.arrivalSdate} 到 {Helper.subStr 0, 10, @state.order?.arrivalEdate}
					</span>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">货物名称: <span>{@state.order?.goodsName}</span></p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<img src={Image.getFullPath @state.order?.goodsPic, Constants.carPicSize} />
					</div>
					<div className="g-pro-text fl">
						<p>货物名字: <span>{@state.order?.goodsName}</span></p>
						<p>货物种类: <span>{@state.order?.goodsType}</span></p>
						<p>货物重量: <span>{@state.order?.goodsWeight}吨</span></p>
						<p>包装类型: <span>{@state.order?.goodsPackingType}</span></p>
					</div>
				</div>
			</div>
			<div className={if @state.order?.orderState is '1' && @state.order?.orderType is 'GC' || @state.order?.orderState is '4' then 'm-detail-info' else 'm-detail-info m-nomargin'} >
				<p>
					<span>发货人:</span>
					<span className="ll-font g-info-name">{@state.order?.shipper}</span>
				</p>
				<p>
					<span>收货人:</span>
					<span className="ll-font g-info-name">{@state.order?.receiver}</span>
				</p>
				<p>
					<span>价格类型:</span>
					<span>{Helper.priceTypeMapper @state.order?.priceType} {@state.order?.price}元</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>{Helper.payTypeMapper @state.order?.payType}</span>
				</p>
				<p>
					<span>发票:</span>
					<span>{Helper.isInvoinceMap @state.order?.isInvoice}</span>
				</p>
				<p>
					<span>发布时间:</span>	
					<span>{Helper.subStr 0, 10, @state.order?.createTime}</span>
				</p>			
			</div>	
			<div className="m-detail-bottom" style={{display: if @state.order?.orderState is '1' && @state.order?.orderType is 'GC' || @state.order?.orderState is '4' then 'block' else 'none'}}>
				<div className="g-pay-btn">
					{
						if @state.order?.orderState is '1'
							if @state.order?.orderType is 'GC'
								<a href="#" className="u-btn02">确定</a>
								<a href="#" className="u-btn02">取消</a>
						else if @state.order?.orderState is '4'
							<a href="###" onClick={@_comment.bind this, @state.order.goodsPersonUserId, @state.order.orderNo} className="u-btn02">评价货主</a>
					}
				</div>
			</div>
		</div>
}

React.render <OrderDetail />, document.getElementById('content')
