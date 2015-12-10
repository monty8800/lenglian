# 车主订单详情
require 'components/common/common'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
Plugin = require 'util/plugin'
Helper = require 'util/helper'
Constants = require 'constants/constants'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'
DB = require 'util/storage'
UserStore = require 'stores/user/user'
XeImage = require 'components/common/xeImage'
Image = require 'util/image'
Raty = require 'components/common/raty'
avatar = require 'user-01'
Auth = require 'util/auth'
_user = UserStore.getUser()
title = null
_index = null

OrderDetail = React.createClass {

	getInitialState: ->
		detail = DB.get 'car_owner_order_detail'
		_index = detail[3]
		{
			carPersonUserId: detail[0]
			orderNo: detail[1]
			goodsPersonUserId: detail[2]
			orderCarId: detail[3]
			order: OrderStore.getOrderDetail()
			wishlst: false
			isInit: true
			mjRateflag: null
		}

	componentDidMount: ->
		OrderAction.carOwnerOrderDetail(@state.carPersonUserId, @state.orderNo, @state.goodsPersonUserId, @state.orderCarId)			
		OrderStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] is 'car_owner_order_detail'
			detail = OrderStore.getOrderDetail()
			newState = Object.create @state
			newState.order = detail
			newState.isInit = false
			newState.wishlst = detail.wishlst
			newState.mjRateflag = detail.mjRateflag
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
		else if params[0] is 'orderDetailCommentUpdate'
			@setState {
				mjRateflag: true
			}

	attention: (flag, goodsPersonUserId)->
		#Auth.needLogin ->
		type = ''
		if flag
			# 关注
			type = 2
		else
			# 取消关注
			type = 1
		# 关注类型 1:货主 2：司机 3：仓库
		OrderAction.attention({
			focusid: goodsPersonUserId
			focustype: '1'	#车主订单 交易对象必定是货主
			userId: _user?.id
			type: type
		})

	# 车主详情
	_goPage: ->
		# item = @state.order.toJS()
		# id = item?.goodsSourceId
		# focusid = item?.goodsPersonUserId
		# DB.put 'transData', {
		# 	goodsId: id
		# 	focusid: focusid
		# 	orderNo: item.orderNo
		# 	orderStatus: title
		# }
		# Plugin.nav.push ['searchGoodsDetail']


	_comment: (targetId, orderNo)->
		DB.put 'transData', {
			userRole: '2'
			targetId: targetId
			targetRole: '1'
			orderNo: orderNo
		}
		Plugin.nav.push ['doComment']

	_tel: (tel)->
		console.log '--------tel:', tel
		window.location.href = 'tel:' + tel

	operation: (params, carPersonUserId, orderNo, version, orderCarId)->
		if params is 1 
			Plugin.alert '确认接受吗?', '提示', (index)->
				if index is 1
					OrderAction.carOwnercomfitOrder2 carPersonUserId, orderNo, version, orderCarId, _index
			, ['确定', '取消']
		else if params is 2	
			Plugin.alert '确定取消吗', '提示', (index)->
				if index is 1
					OrderAction.carOwnerCancelOrder carPersonUserId, orderNo, version, orderCarId, _index
			, ['确定', '取消']
		else if params is 3
			Plugin.alert '确定卸货吗', '提示', (index)->
				if index is 1
					OrderAction.postAlreadyStatus {
						userId: UserStore.getUser().id
						orderNo: carPersonUserId
						orderSubState: 3
						version: version
						flag: 2
					}
			, ['确定', '取消']
		else if params is 4
			Plugin.alert '确定发送吗', '提示', (index)->
				if index is 1
					OrderAction.postAlreadyStatus {
						userId: UserStore.getUser().id
						orderNo: carPersonUserId
						orderSubState: 2
						version: version
						flag: 2
					}
			, ['确定', '取消']

	render: ->

		unPaidAmount = parseFloat @state.order?.price - parseFloat @state.order?.paidAmount

		if @state.order?.orderState is '1'
			if @state.order?.orderType is 'CG'
				title = '等待货主同意'
			else
				# 2015-10-21 如果这块有问题，果断去掉这块逻辑
				title = '洽谈中'
		else if @state.order?.orderState is '2'
			# 1：货到付款（线下）2：回单付款（线下） 3：预付款（线上）
			if @state.order?.payType is '3'
				title = '等待货主付款'
			else
				title = '货物运输中'
		else if @state.order?.orderState is '3'
			if @state.order.subState is '2'
				title = '已发送到货通知'
			else if @state.order.subState is '4'
				title = '等待货主收货'
			else
				title = '货物运输中'
		else if @state.order?.orderState is '4'
			if @state.mjRateflag is true
				title = '已评价'
			else
				title = '待评价'
		else if @state.order?.orderState is '5'
			title = '订单已取消'

		_payTypeText = Helper.payTypeMapper @state.order?.payType
		# if parseInt(@state.order?.payType) is 3 and @state.order?.advance
		# 	_payTypeText = _payTypeText + @state.order?.advance + '元'

		console.log '-----------goodsRouteList:', @state.order.goodsRouteList
		routeList = []
		if @state.order.goodsRouteList isnt null and @state.order.goodsRouteList isnt ''
			routeList = @state.order.goodsRouteList.split ','
		routes = routeList.map (item, index)->
			<div className="g-adr-middle ll-font g-adr-middle-line" key={index}>
				{item}				
			</div>

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
							<div className="g-dirver-dis ll-font">
								{
									if not @state.isInit
										<Raty score={@state.order.goodScore} />
								}
							</div>
						</div>
						<ul className="g-driver-contact">
							<li className={ if @state.wishlst then "ll-font" else 'll-font active'} onClick={@attention.bind this, @state.wishlst, @state.order?.goodsPersonUserId}>关注</li>
							<li className="ll-font" onClick={@_tel.bind this, @state.order.goodsPersonMobile}>拨号</li>
						</ul>
					</div>
				</div>
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-start ll-font g-adr-start-line">
						<em>{@state.order.destination + '-' + @state.order.goodsToStreet}</em>
						<span></span>
					</div>
					{
						if routeList.length > 0
							routes
					}
					
					<div className="g-adr-end ll-font g-adr-end-line">
						<em>{@state.order.setOut + '-' + @state.order.goodsFromStreet}</em>
						<span></span>
					</div>	
				</div>
			</div>
			<div className="m-item01" style={{display: if @state.order?.loadingSdate is '' then 'none' else 'block' }}>
				<div className="g-detail-time01">
					<span className="fl">装货时间:</span>
					<span className="fr">
						{Helper.subStr 0, 10, @state.order?.loadingSdate} 到 {Helper.subStr 0, 10, @state.order?.loadingEdate}
					</span>
				</div>
			</div>
			<div className="m-item01" style={{display: if @state.order?.arrivalSdate is '' then 'none' else 'block' }}>
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
				<div className="g-pro-detail clearfix">
					<div className="g-pro-pic fl">
						<XeImage src={@state.order?.goodsPic} size=Constants.carPicSize />
					</div>
					<div className="g-pro-text fl">
						<p>货物种类: <span>{@state.order?.goodsType}</span></p>
						<p>货物规格: <span>{if @state.order?.goodsWeight then @state.order?.goodsWeight + '吨' else ''}{@state.order?.goodsCubic + '方'}</span></p>
						<p>包装类型: <span>{@state.order?.goodsPackingType}</span></p>
					</div>
				</div>
			</div>
			<div className={if @state.order?.orderState is '1' && @state.order?.orderType is 'GC' || @state.order?.orderState is '4' then 'm-detail-info' else 'm-detail-info'} >
				<p>
					<span>发货人:</span>
					<span onClick={@_tel.bind this, @state.order.shipperMobile} className="ll-font g-info-name">{@state.order?.shipper}</span>
				</p>
				<p>
					<span>收货人:</span>
					<span onClick={@_tel.bind this, @state.order.receiverMobile} className="ll-font g-info-name">{@state.order?.receiver}</span>
				</p>
				<p>
					<span>价格类型:</span>
					<span>{Helper.priceTypeMapper @state.order?.priceType}{parseFloat(@state.order?.paidAmount).toFixed(2)}元</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>{ _payTypeText }</span>
				</p>
				<p>
					<span>已付金额:</span>
					<span>{ parseFloat(@state.order?.paidAmount).toFixed(2) + '元' }</span>
				</p>
				<p>
					<span>未付金额:</span>
					<span>{ unPaidAmount.toFixed(2) + '元' }</span>
				</p>				
				<p>
					<span>发票:</span>
					<span>{Helper.isInvoinceMap @state.order?.isInvoice}</span>
				</p>
				<p>
					<span>货源发布时间:</span>	
					<span>{Helper.subStr 0, 10, @state.order?.releaseTime}</span>
				</p>	
				{ 
					if @state.order?.goodsRemark
						<p>
							<span>货物备注:</span>	
							<span>{ @state.order?.goodsRemark }</span>
						</p>
				}
			</div>	

			<div className="m-detail-bottom" style={{display: if @state.order?.orderState is '3' and @state.order?.subState is '1' or @state.order?.subState is '3' then 'block' else 'none'}}>
				<div className="g-pay-btn">
					<a href="###" className="u-btn02 u-btn02-large" style={{display: if @state.order?.subState is '1' then 'block' else 'none' }} onClick={@operation.bind this, 4, @state.order.orderNo, @state.order.subState, @state.order.version}>发送到货通知</a>
				</div>
				<div className="g-cancle-btn">
					<a href="###" className="u-btn02 u-btn02-large" style={{display: if @state.order?.subState is '3' then 'block' else 'none' }} onClick={@operation.bind this, 3, @state.order.orderNo, @state.order.subState, @state.order.version}>卸货完毕</a>
				</div>
			</div>

			<div className="m-detail-bottom" style={{display: if @state.order?.orderState is '1' then 'block' else 'none'}}>
				{
					if  @state.order?.orderType is 'GC'
						<div className="g-pay-btn">
							<a className="u-btn02" onClick={@operation.bind this, 1, @state.order.carPersonUserId, @state.order.orderNo, @state.order.version, @state.order.orderCarId}>接受</a>
						</div>
				}
				{
					if @state.order?.priceType is '1'
						if @state.order?.orderType is 'GC'
							<div className="g-cancle-btn">
								<a className="u-btn02 u-btn-cancel" onClick={@operation.bind this, 2, @state.order.carPersonUserId, @state.order.orderNo, @state.order.version, @state.order.orderCarId}>取消</a>
							</div>
						else
							<div className="g-pay-btn">
								<a className="u-btn02 u-btn-cancel" onClick={@operation.bind this, 2, @state.order.carPersonUserId, @state.order.orderNo, @state.order.version, @state.order.orderCarId}>取消</a>
							</div>
				}
			</div>
			<div className="m-detail-bottom" style={{display: if @state.order?.orderState is '4' and @state.mjRateflag is false then 'block' else 'none'}}>
				<div className="g-pay-btn">
					<a href="###" className="u-btn02" onClick={@_comment.bind this, @state.order.goodsPersonUserId, @state.order.orderNo}>发表评论</a>
				</div>
			</div>
		</div>
}

React.render <OrderDetail />, document.getElementById('content')
