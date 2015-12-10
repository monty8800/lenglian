# 车主订单Cell
require 'components/common/common'
React = require 'react/addons'
CSSTransitionGroup = React.addons.CSSTransitionGroup
Plugin = require 'util/plugin'
Helper = require 'util/helper'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'
DB = require 'util/storage'
UserStore = require 'stores/user/user'
XeImage = require 'components/common/xeImage'
Raty = require 'components/common/raty'
avatar = require 'user-01'

CarItem = React.createClass {

	getInitialState: ->
		{
			isInit: false
		}	

	# 发送到货通知、卸货完毕
	newPro: (orderNo, subState, version, e)->
		OrderAction.postAlreadyStatus {
			userId: UserStore.getUser().id
			orderNo: orderNo
			orderSubState: subState
			version: version
			flag: 1
		}
		e.stopPropagation()

	# 接受
	_receiver: (type, item, i, e)->
		Plugin.alert '确认接受吗?', '提示', (index)->
			if index is 1
				if type is 1 # 接受
					OrderAction.carOwnercomfitOrder(item?.carPersonUserId, item?.orderNo, item.version, item.orderCarId, i)
				else if type is 2 # 取消
					OrderAction.carOwnerCancelOrder(item?.carPersonUserId, item?.orderNo, item.version, item.orderCarId, i)
		, ['确定', '取消']
		e.stopPropagation()

	comment: (targetId, orderNo, i, e)->
		DB.put 'transData', {
			userRole: '2'
			targetId: targetId
			targetRole: '1'
			orderNo: orderNo
		}
		Plugin.nav.push ['doComment']
		e.stopPropagation()
		
	_detail: (item, i)->
		console.log '---------orderCarId:', item.orderCarId 
		DB.put 'car_owner_order_detail', [item?.carPersonUserId, item?.orderNo, item?.goodsPersonUserId, item.orderCarId, i]
		Plugin.nav.push ['carOwnerOrderDetail']

	componentDidMount: ->			
		OrderStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] is 'car_owner_confirm_order_success'
			# 车主确认订单成功
			orderList = @props.items.splice params[1], 1
			newState = Object.create @state
			newState.orderList = orderList
			@setState newState
		else if params[0] is 'car_owner_cancel_order_success'
			#车主取消订单成功
			orderList = @props.items.splice params[1], 1
			newState = Object.create @state
			newState.orderList = orderList
			@setState newState
		else if params[0] is 'car_fresh'
			# indexsss = DB.get 'detailCallBackFlag'
			# console.log '---------hahahha:', indexsss
			# if indexsss isnt null
			# 	orderList = @props.items.splice parseInt(indexsss), 1
			# 	console.log '---------hahahha:', orderList
			# 	newState = Object.create @state
			# 	newState.orderList = orderList
			# 	@setState newState
			# DB.remove 'detailCallBackFlag'
		else if params[0] is 'car' or params[0] is 'goods' or params[0] is 'store'
			@setState {
				isInit: false
			}
		else if params[0] is 'commentSuccess'
			console.log '---------评价成功'

	render: ->
		items = @props.items.map (item, i)->
			console.log '-------------items:', item
			<div className="m-item01" key={item?.orderCarId} onClick={@_detail.bind this, item, i}>
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<XeImage src={item?.goodsPersonHeadPic} size='130x130' type='avatar' />
						</div>	
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<div>{item?.goodsPersonName}</div>
							</div>
							<div className="g-dirver-dis ll-font">	
								{
									if not @state.isInit
										<Raty score={item?.goodsPersonScore} />
								}
							</div>
						</div>
						<div className="g-dirver-btn">
							{
								if item?.orderState is '1'
									if item?.orderType is 'CG'
										<span>等待货主同意</span>
									else if item?.orderType is 'GC'
										<a href="###" onClick={@_receiver.bind this, 1, item, i} className="u-btn02">接受</a>
										#<a href="###" onClick={@_receiver.bind this, 2, item, i} className="u-btn02">取消</a>
								else if item?.orderState is '2'
									# 1：货到付款（线下）2：回单付款（线下） 3：预付款（线上）
									# if item?.payType is '3'
									# 	<span>等待货主付款</span>				
									# else
									# 	<span>货物运输中</span>
									<span>等待货主付款</span>				
								else if item?.orderState is '3'
									# <span>货物运输中</span>
									if item?.subState is '1'
										<a href="###" className="u-btn02 u-btn02-large" onClick={@newPro.bind this, item?.orderNo, 2, item?.version}>发送到货通知</a>
									else if item?.subState is '2'
										<span>已发送到货通知</span>
									else if item?.subState is '3'
										<a href="###" className="u-btn02 u-btn02-large" onClick={@newPro.bind this, item?.orderNo, 3, item?.version}>卸货完毕</a>
									else if item?.subState is '4'
										<span>等待货主收货</span>
								else if item?.orderState is '4'
									if item?.mjRateflag is true
										<span>已评价</span>
									else
										<a href="###" onClick={@comment.bind this, item?.goodsPersonUserId, item?.orderNo, i} className="u-btn02">发表评论</a>
								else if item?.orderState is '5'
									<span>订单已取消</span>
							}
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						<em>{item?.destination}</em>
						<span></span>
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						<em>{item?.setOut}</em>
						<span></span>
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型 : 
						<span>{Helper.priceTypeMapper item?.priceType}{if parseInt(item?.priceType) is 1 then item?.price + '元' else item?.bidPrice + '元'}</span>
					</p>
					<p>货物描述 : <span>{item?.goodsName}</span><span>{if item?.goodsWeight then item?.goodsWeight + '吨' else ''}</span><span>{if item?.goodsCubic then item?.goodsCubic + '方'}</span><span>{ if item?.goodsType then item?.goodsType }</span></p>
					<p>支付方式 : <span>{Helper.payTypeMapper item?.payType}</span></p>
				</div>
			</div>
		, this
		<div>
		<CSSTransitionGroup transitionName="list">
		{items}
		</CSSTransitionGroup>
		</div>
}

module.exports = CarItem
# <span>{if parseInt(item.payType) is 3 then item.advance + '元' else ''}</span>
