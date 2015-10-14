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

#TODO:  少是否关注字段

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
				@_orderDone()

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
		OrderAction.cancelGoodsOrder {
			userId: UserStore.getUser()?.id
			orderNo: @state.detail?.get 'orderNo'
		}

	_agree: ->
		OrderAction.goodsAgree {
			userId: UserStore.getUser()?.id
			orderNo: @state.detail?.get 'orderNo'
		}, @state.detail?.get 'orderNo'


	_goPay: ->
		DB.put 'transData', {
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
		rateFlag = @state.detail?.get 'rateFlag'
		console.log 'go comment', rateFlag
		if not rateFlag
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
			isGC = params.detail.get('orderType') in ['GC', 'CG']
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
		_statusText = null
		_btnText = null
		switch parseInt(@state.detail?.get 'orderState')
			when 1
				_statusText =  '洽谈中'
				_btnText = '接受'
			when 2
				_statusText = '等待货主付款'
				if parseInt(@state.detail?.get 'payType') is 3
					_btnText = '确认付款'
				else
					_btnText = "订单完成"
			when 3
				_statusText = '已付款'
				_btnText = '订单完成'
			when 4
				_statusText = '已付款'
				if @state.detail?.get('orderType') in ['GC', 'CG'] 
					_btnText = '评价司机'
				else
					_btnText = '评价仓库'
			when 5
				_statusText = '已取消'
				_btnText = '重新发布'

		console.log 'state', @state
		<section>
		<div className="m-orderdetail clearfix">
			<p className="fl">订单号：<span>{@state.detail?.get 'orderNo'}</span></p>
			<p className="fr">{_statusText}</p>
		</div>

		<div className="m-item01">
			{
				if parseInt(@state.detail?.get 'orderState') isnt 5
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
			}

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
					<p>货物规格: <span>{@state.detail?.get('goodsWeight') + '吨'}</span></p>
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
				<span>{Moment(@state.detail?.get('createTime')).format('YYYY-MM-DD')}</span>
			</p>			
		</div>
		{
			if parseInt(@state.detail?.get 'orderState') isnt 1 or parseInt(@state.detail?.get 'acceptMode') is 1
				<div className="m-detail-bottom">
					{
						if parseInt(@state.detail?.get 'orderState') is 1
							<div className="g-cancle-btn">
								<a onClick={@_cancel} className="u-btn02 u-btn-cancel">取消订单</a>
							</div>
					}
					<div className="g-pay-btn">
						<a onClick={@_confirm} className="u-btn02">{_btnText}</a>
					</div>
				</div>
		}
		</section>
}

React.render <GoodsOrderDetail />,document.getElementById('content')