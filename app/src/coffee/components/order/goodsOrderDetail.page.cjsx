require 'components/common/common'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

XeImage = require 'components/common/xeImage'

Moment = require 'moment'

Helper = require 'util/helper'

OrderStore = require 'stores/order/order'

OrderAction = require 'actions/order/order'

UserStore = require 'stores/user/user'

transData = DB.get 'transData'

FollowAction = require 'actions/attention/attention'
FollowStore = require 'stores/attention/attention'

Plugin = require 'util/plugin'
Raty = require 'components/common/raty'
GoodsRouteList = React.createClass {
	render : ->
		items = @props.list.map (item,i)->
			<div className="g-adr-middle ll-font">
				{item}
			</div>
		,this
		<div>
			{items}
		</div>
}
GoodsRoutes = React.createClass {
	render : ->
		items = @props.list.map (item,i)->
			<div className="g-adr-middle ll-font">
				{item}			
			</div>
		,this
		<div>
			{items}
		</div>
}

GoodsOrderDetail = React.createClass {

	_confirm: ->
		console.log 'click _confirm!'
		switch parseInt(@state.detail?.get 'orderState')
			when 1
				@_agree()
			when 2
				if parseInt(@state.detail?.get 'payType') is 3
					@_goPay()
				else
					@_orderDone()
			when 3
				if parseFloat(@state.detail?.get 'price') - parseFloat(@state.detail?.get 'paidAmount') < 0.01
					@_orderDone()
				else
					@_goPay()
			when 4
				@_goComment()

			when 5
				@_rePub()

	_rePub: ->
		console.log 'repub order', @state.detail
		OrderAction.repubGoodsOrder {
			userId: UserStore.getUser()?.id
			goodsResourceId: @state.detail?.get 'goodsResourceId'
		}

	_cancel: ->
		console.log 'cancel order', @state.detail
		detail = @state.detail
		Plugin.alert '确认取消订单？', '提醒', (index)->
			if index is 1
				OrderAction.cancelGoodsOrder {
					userId: UserStore.getUser()?.id
					orderNo: detail?.get 'orderNo'
				}
		, ['取消订单', '放弃取消']

	_agree: ->
		detail = @state.detail
		Plugin.alert '确认接受订单？', '提醒', (index)->
			if index is 1
				OrderAction.goodsAgree {
					userId: UserStore.getUser()?.id
					orderNo: detail?.get 'orderNo'
				}, detail?.get 'orderNo'
		, ['接受', '取消']


	_goPay: ->
		# DB.put 'transData', {
		DB.put 'transDataPay', {
			orderNo: @state.detail?.get 'orderNo'
		}
		Plugin.nav.push ['orderPay']

	_orderDone: ->
		detail = @state.detail
		Plugin.alert '确认完成订单?', '提醒', (index)->
			console.log 'click index', index
			if index is 1
				OrderAction.goodsOrderDone {
					userId: UserStore.getUser()?.id
					orderNo: detail.get 'orderNo'
				}, detail.get 'orderNo'
		, ['完成订单', '取消']

	_goComment: ->
		rateFlag = @state.detail?.get 'mjRateflag'
		console.log 'go comment', rateFlag
		if rateFlag
			return
		DB.put 'transData', {
			userRole: '1'
			targetId: @state.targetId
			targetRole: if @state.isGC then 2 else 3
			orderNo: @state.detail.get 'orderNo'
		}

		Plugin.nav.push ['doComment']

	_call: (mobile)->
		console.log 'call', mobile
		if mobile
			window.location.href = 'tel://' + mobile

	_follow: ->
		# focustype 1:货主 2：司机 3：仓库
		FollowAction.follow {
			focusid: @state.targetId
			focustype: if @state.isGC then 2 else 3
			userId: UserStore.getUser()?.id
			type: if @state.followed then 2 else 1
		}

	_toOnwerDetail:-> 
		if @state.isGC	#carId dUserId carNo carStatus
			DB.put 'transData', [@state.id, @state.targetId, @state.ordeNo, @state.sourceId]
			# Plugin.nav.push ['carOnwerDetail']
			Plugin.nav.push ['carSourceDetail']
		else
			DB.put 'transData', {orderId:@state.ordeNo,warehouseId:@state.id,focusid:@state.targetId }
			Plugin.nav.push ['warehouseOnwerDetail']


	componentDidMount: ->
		OrderStore.addChangeListener @resultCallBack
		OrderAction.goodsOrderDetail {
			userId: UserStore.getUser()?.id
			orderNo: transData?.orderNo
		}

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		console.log 'event change', params
		if params.msg is 'goods:order:detail:done'
			isGC = params.detail.get('orderType') in ['GC', 'CG']
			@setState {
				detail: params.detail
				isGC: isGC
				id:if isGC then params.detail.get('carId') else params.detail.get('warehouseId')
				sourceId: params.detail.get(if isGC then 'carSourceId' else 'warehouseSourceId')
				ordeNo : params.detail?.get('orderNo')
				target: if isGC then params.detail.get('carUserName') else params.detail.get('warehouseUserName')
				targetId: if isGC then params.detail.get('carUserId') else params.detail.get('warehouseUserId')
				targetMobile: if isGC then params.detail.get('carUserMobile') else params.detail.get('warehouseUserMobile')
				targetPic: if isGC then params.detail.get('carUserHeadPic') else params.detail.get('warehouseUserHeadPic')
				targetAuth: if isGC then params.detail.get('carUserAuthMode') else params.detail.get('warehouseUserAuthMode')
				targetScore: if isGC then params.detail.get('carUserScore') else params.detail.get('warehouseUserScore')
				followed: params.detail.get('wishFlag')
				goodsRouteList:if isGC then params.detail.get('goodsRouteList') else null
			}
		else if params.msg is 'follow:done'
			@setState {
				followed: params.followed
			}
		else if params?[0] is 'orderDetailCommentUpdate'
			@setState {
				detail: @state.detail.set 'mjRateflag', true
			}

	getInitialState: ->
		{
			detail: null
			followed: false
		}

	render : ->
		toColdFlag = if parseInt(@state.detail?.get('coldStoreFlag')) in [4, 3] then '（需要冷库）' else ''
		fromColdFlag = if parseInt(@state.detail?.get('coldStoreFlag')) in [4, 2] then '（需要冷库）' else ''
		_statusText = null
		_btnText = null
		orderState = parseInt(@state.detail?.get 'orderState')
		acceptMode = parseInt(@state.detail?.get 'acceptMode')
		# switch parseInt(@props.order?.orderState)
		# 	when 1
		# 		switch parseInt(@props.order?.acceptMode)
		# 			when 1
		# 				_statusText = "等待您的同意"
		# 			when 2
		# 				_statusText = "等待司机同意"
		# 			when 3
		# 				_statusText = "等待仓库同意"
			# when 2  #待付款
			# 	if parseInt(@props.order?.payType) is 3  #支付方式 1：货到付款 2：回单付款 3：预付款
			# 		if parseInt(@props.order?.payState) is 2
			# 			statusBtn = <span>支付处理中</span>
			# 		else
			# 			statusBtn = <a onClick={@_receiver} className="u-btn02">确认付款</a>
			# 	else
			# 		statusBtn = <a onClick={@_receiver} className="u-btn02">确认收货</a>
			# when 3	#已付款
			# 	if parseInt(@props.order?.payState) is 2
			# 		statusBtn = <span>支付处理中</span>
			# 	else
			# 		if parseFloat(@props.order.price) - parseFloat(@props.order.paidAmount) < 0.01
			# 			# 全款支付了
			# 			statusBtn = <a onClick={@_receiver} className="u-btn02">确认收货</a>
			# 		else
			# 			statusBtn = <a onClick={@_receiver} className="u-btn02">支付运费余款</a>
						
			# when 4
			# 	if not @props.order?.mjRateflag
			# 		if @props.order?.orderType in ['GC', 'CG']
			# 			statusBtn = <a onClick={@_receiver} className="u-btn02">评价司机</a>
			# 		else
			# 			statusBtn = <a onClick={@_receiver} className="u-btn02">评价仓库</a>
			# 	else
			# 		statusBtn = <span>订单已评价</span>

		switch orderState
			when 1
				_statusText =  '洽谈中'
				switch acceptMode
					when 1
						_statusText = "等待您的同意"
					when 2
						_statusText = "等待司机同意"
					when 3
						_statusText = "等待仓库同意"
				_btnText = '接受'
			when 2
				_statusText = '待付款'
				# if parseInt(@state.detail?.get 'payType') is 3 
					#支付方式 1：货到付款 2：回单付款 3：预付款
				_statusText = '订单处理中' if parseInt(@state.detail?.get 'payState') is 2
				_btnText = '确认付款'
				# else
				# 	_btnText = "确认收货"
			when 3
				_statusText = '已付款'
				if parseFloat(@state.detail?.get 'price') - parseFloat(@state.detail?.get 'paidAmount') < 0.01
					_btnText = '确认收货'
				else
					_btnText = '支付运费余款'
				
			when 4
				_statusText = '待评价'
				if not @state.detail?.get 'mjRateflag'
					_btnText = '发表评论'
					# if @state.detail?.get('orderType') in ['GC', 'CG'] 
					# 	_btnText = '评价司机'
					# else
					# 	_btnText = '评价仓库'
				else
					_btnText = '订单已评价'
					_statusText = '订单已评价'
			when 5
				_statusText = '已取消'
				_btnText = '重新发布'

		_payTypeText = Helper.payTypeMapper (@state.detail?.get 'payType')
		# if (@state.detail?.get 'advance')
		# 	_payTypeText = _payTypeText + parseFloat(@state.detail?.get 'advance').toFixed(2) + '元'


		console.log 'state', @state
		<section>
		<div className="m-orderdetail clearfix">
			<p className="fl">订单号：<span>{@state.detail?.get 'orderNo'}</span></p>
			<p className="fr">{_statusText}</p>
		</div>

		<div className="m-item01">
			<div className="g-detail-dirver">
				{
					if parseInt(@state.detail?.get('priceType')) is 1 or orderState isnt 1
						<div className="g-detail">					
							<div onClick={@_toOnwerDetail} className="g-dirver-pic">
								<XeImage src={@state.targetPic} size='130x130' type='avatar' />
							</div>
							<div className="g-dirver-msg">
								<div className="g-dirver-name">
									<span>{@state.target}</span><span className="g-dirname-single">{if parseInt(@state.targetAuth) is 1 then '(个体)' else '(公司)'}</span>
								</div>
								<div className="g-dirver-dis ll-font">
									<Raty score={ @state.targetScore } />
								</div>

							</div>
							<ul className="g-driver-contact">
								<li onClick={@_follow} className={"ll-font " + if @state.followed then '' else 'active'}>关注</li>
								<li onClick={@_call.bind this, @state.targetMobile} className="ll-font">拨号</li>
							</ul>
						</div>
				}

			</div>

			<div className="g-item g-adr-detail ll-font nopadding">			
				<div className="g-adr-start ll-font g-adr-start-line">
					<em>{@state.detail?.get('toProvinceName') + @state.detail?.get('toCityName') + @state.detail?.get('toCountyName') + @state.detail?.get('toStreet') + toColdFlag}</em>
					<span></span>
				</div>
				{
					if @state.goodsRouteList
						<GoodsRouteList list={@state.goodsRouteList.split ','} />
				}
				<div className="g-adr-end ll-font g-adr-end-line">
					<em>{@state.detail?.get('fromProvinceName') + @state.detail?.get('fromCityName') + @state.detail?.get('fromCountyName') + @state.detail?.get('fromStreet') + fromColdFlag}</em>
					<span></span>
				</div>	
			</div>
		</div>
		<div className="m-item01">
			<div className="g-detail-time01">
				<span className="fl">装货时间:</span>
				<span className="fr">
					{Moment(@state.detail?.get('loadingSdate')).format('YYYY-MM-DD') + ' 到 ' + Moment(@state.detail?.get('loadingEdate')).format('YYYY-MM-DD')}
				</span>
			</div>
			{
				if @state.detail?.get('arrivalSdate')
					<div className="g-detail-time01">
						<span className="fl">到货时间:</span>
						<span className="fr">
							{Moment(@state.detail?.get('arrivalSdate')).format('YYYY-MM-DD') + ' 到 ' + Moment(@state.detail?.get('arrivalEdate')).format('YYYY-MM-DD')}
						</span>
					</div>
			}

		</div>
		<div className="m-item01">
			<div className="g-pro-p">
				<p className="g-pro-name">货物名称: <span>{@state.detail?.get('goodsName')}</span></p>
			</div>
			<div className="g-pro-detail clearfix">
				<div className="g-pro-pic fl">
					<XeImage src={@state.detail?.get('goodsPic')} size='200x200' />
				</div>
				<div className="g-pro-text fl">
					<p>货物种类: <span>{@state.detail?.get('goodsType')}</span></p>

					<p>货物规格: <span>{if @state.detail?.get('goodsWeight') then @state.detail?.get('goodsWeight') + '吨' else ''}</span><span>{ if @state.detail?.get('goodsCubic') then @state.detail?.get('goodsCubic') + '方' else ''}</span></p>

					<p>包装类型: <span>{@state.detail?.get('goodsPackingType')}</span></p>
				</div>
			</div>
		</div>
		<div className="m-detail-info">			
			<p>
				<span>发货人:</span>
				<span onClick={@_call.bind this, @state.detail?.get('shipperMobile')}  className="ll-font g-info-name">{@state.detail?.get('shipper')}</span>
			</p>
			<p>
				<span>收货人:</span>
				<span onClick={@_call.bind this, @state.detail?.get('receiverMobile')} className="ll-font g-info-name">{@state.detail?.get('receiver')}</span>
			</p>
			<p>
				<span>价格类型:</span>
				<span>{(if parseInt(@state.detail?.get('priceType')) is 1 then '一口价' else '竞价') + parseFloat(@state.detail?.get('price')).toFixed(2) + '元'}</span>
			</p>
			<p>
				<span>支付方式:</span>
				<span>{_payTypeText}</span>
			</p>
			<p>
				<span>已付款金额:</span>
				<span>{ parseFloat(@state.detail?.get('paidAmount')).toFixed(2) + '元' }</span>
			</p><p>
				<span>未付款金额:</span>
				<span>{ (parseFloat(@state.detail?.get('price')) - parseFloat(@state.detail?.get('paidAmount'))).toFixed(2) + '元' }</span>
			</p>
			<p>
				<span>发票:</span>
				<span>{Helper.isInvoinceMap @state.detail?.get('goodsIsInvoice')}</span>
			</p>
			<p>
				<span>货源发布时间:</span>
				<span>{Moment(@state.detail?.get('goodsCreateTime')).format('YYYY-MM-DD')}</span>
			</p>
			{
				if @state.detail?.get('goodsRemark')
					<p>
						<span>货物备注:</span>
						<span>{ @state.detail?.get('goodsRemark') }</span>
					</p>
			}			
		</div>
		<div className={if _statusText not in ['订单已评价', '已取消'] then 'm-detail-bottom' else ''}>
			{
				if orderState is 1
					<div className={if acceptMode is 1 and parseInt(@state.detail?.get 'priceType') is 1 then "g-cancle-btn" else 'g-pay-btn'}>
						<a onClick={@_cancel} className="u-btn02 u-btn-cancel">取消</a>
					</div>
			}
			{
				if orderState isnt 5 and not (orderState is 1 and (acceptMode isnt 1 or parseInt(@state.detail?.get 'priceType') isnt 1)) and not (orderState is 4 and @state.detail?.get 'mjRateflag') and not (orderState is 2 and parseInt(@state.detail?.get 'payState') is 2)
					<div className="g-pay-btn">
						<a onClick={@_confirm} className="u-btn02">{_btnText}</a>
					</div>
			}

		</div>
		</section>
}

React.render <GoodsOrderDetail />,document.getElementById('content')