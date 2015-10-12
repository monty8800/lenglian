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

#TODO:  少是否关注字段

GoodsOrderDetail = React.createClass {
	# _statusText: ->
	# 	switch parseInt(@state.detail)
	# 		when 
	_confirm: ->
		console.log 'click recive!'
		switch parseInt(@state.detail?.orderState)
			when 1
				@_agree()
			when 2
				if parseInt(@state.detail?.payType) is 3
					@_goPay()
				else
					@_orderDone()
			when 3
				@_orderDone()

			when 4
				@_goComment()

	_agree: ->
		OrderAction.goodsAgree {
			userId: UserStore.getUser()?.id
			orderNo: @state.detail?.orderNo
		}, @state.detail?.orderNo


	_goPay: ->
		DB.put 'transData', {
			orderNo: @state.detail?.orderNo
		}
		Plugin.nav.push ['orderPay']

	_orderDone: ->
		Plugin.alert '确认完成订单?', '提醒', (index)->
			console.log 'click index', index
			if index is 1
				OrderAction.goodsOrderDone {
					userId: UserStore.getUser()?.id
					orderNo: @state.detail?.orderNo
				}, @state.detail?.orderNo
		, ['完成订单', '取消']

	_goComment: ->
		Plugin.nav.push ['doComment']

	_call: (mobile)->
		console.log 'call', mobile
		window.location.href = 'tel://' + mobile

	_follow: ->
		FollowAction.follow {
			focusid: @state.targetId
			focustype: if @state.isGC then 1 else 3
			userId: UserStore.getUser()?.id
			type: if @state.followed then 2 else 1
		}
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
			isGC = params.detail.get('orderType') is 'GC'
			@setState {
				detail: params.detail
				isGC: isGC
				target: if isGC then params.detail.get('carUserName') else params.detail.get('warehouseUserName')
				targetId: if isGC then params.detail.get('carUserId') else params.detail.get('warehouseUserId')
				targetMobile: if isGC then params.detail.get('carUserMobile') else params.detail.get('warehouseUserMobile')
				targetPic: if isGC then params.detail.get('carUserHeadPic') else params.detail.get('warehouseUserHeadPic')
				targetAuth: if isGC then params.detail.get('carUserAuthMode') else params.detail.get('warehouseUserAuthMode')
				targetScore: if isGC then params.detail.get('carUserScore') else params.detail.get('warehouseUserScore')
			}
		else if params.msg is 'follow:done'
			@setState {
				followed: params.followed
			}

	getInitialState: ->
		{
			detail: null
			followed: false
		}

	render : ->
		<section>
		<div className="m-orderdetail clearfix">
			<p className="fl">订单号：<span>{@state.detail?.get 'orderNo'}</span></p>
			<p className="fr">等待货主付款</p>
		</div>

		<div className="m-item01">
			<div className="g-detail-dirver">
				<div className="g-detail">					
					<div className="g-dirver-pic">
						<XeImage src={@state.targetPic} size='130x130' type='avatar' />
					</div>
					<div className="g-dirver-msg">
						<div className="g-dirver-name">
							<span>{@state.target}</span><span className="g-dirname-single">{if parseInt(@state.targetAuth) is 1 then '(个体)' else '(公司)'}</span>
						</div>
						<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
					</div>
					<ul className="g-driver-contact">
						<li onClick={@_follow} className={"ll-font " + if @state.followed then 'active' else ''}>关注</li>
						<li onClick={@_call.bind this, @state.targetMobile} className="ll-font">拨号</li>
					</ul>
				</div>
			</div>
			<div className="g-item g-adr-detail ll-font nopadding">			
				<div className="g-adr-start ll-font g-adr-start-line">
					{@state.detail?.get('fromProvinceName') + @state.detail?.get('fromCityName') + @state.detail?.get('fromCountyName')}
				</div>
				
				<div className="g-adr-end ll-font g-adr-end-line">
					{@state.detail?.get('toProvinceName') + @state.detail?.get('toCityName') + @state.detail?.get('toCountyName')}
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
			<div className="g-pro-detail">
				<div className="g-pro-pic fl">
					<XeImage src={@state.detail?.get('goodsPic')} />
				</div>
				<div className="g-pro-text fl">
					<p>货物种类: <span>{@state.detail?.get('goodsType')}</span></p>
					<p>货物重量: <span>{@state.detail?.get('goodsWeight') + '吨'}</span></p>
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
				<span>{(if parseInt(@state.detail?.get('priceType')) is 1 then '一口价' else '竞价') + @state.detail?.get('price') + '元'}</span>
			</p>
			<p>
				<span>支付方式:</span>
				<span>{Helper.payTypeMapper @state.detail?.get('payType')}</span>
			</p>
			<p>
				<span>发票:</span>
				<span>{Helper.isInvoinceMap @state.detail?.get('isInvoice')}</span>
			</p>
			<p>
				<span>发布时间:</span>
				<span>{@state.detail?.get('createTime')}</span>
			</p>			
		</div>
		<div className="m-detail-bottom">
			<div className="g-pay-btn">
				<a onClick={@_confirm} className="u-btn02">确认付款</a>
			</div>
		</div>
		</section>
}

React.render <GoodsOrderDetail />,document.getElementById('content')