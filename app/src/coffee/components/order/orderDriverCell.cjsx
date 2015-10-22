React = require 'react'

XeImage = require 'components/common/xeImage'

OrderAction = require 'actions/order/order'

UserStore = require 'stores/user/user'

DB = require 'util/storage'
Plugin = require 'util/plugin'

#TODO: 评分
OrderDriverCell = React.createClass {
	_receiver: ->
		console.log 'click recive!'
		switch parseInt(@props.order?.orderState)
			when 1
				@_agree()
			when 2
				if parseInt(@props.order?.payType) is 3
					@_goPay()
				else
					@_orderDone()
			when 3
				@_orderDone()

			when 4
				@_goComment()

	_agree: ->
		order = @props.order
		Plugin.alert '确认接受订单?', '提醒', (index)->
			if index is 1
				OrderAction.goodsAgree {
					userId: UserStore.getUser()?.id
					orderNo: order?.orderNo
				}, order?.orderNo
		, ['接受', '取消']


	_goPay: ->
		# DB.put 'transData', {
		DB.put 'transDataPay', {		
			orderNo: @props.order?.orderNo
		}
		Plugin.nav.push ['orderPay']

	_orderDone: ->
		orderNo = @props.order?.orderNo
		Plugin.alert '确认完成订单?', '提醒', (index)->
			console.log 'click index', index
			if index is 1
				OrderAction.goodsOrderDone {
					userId: UserStore.getUser()?.id
					orderNo: orderNo
				}, orderNo
		, ['完成订单', '取消']

	_goComment: ->
		console.log 'o---rder', @props.order
		if  @props.order?.mjRateflag
			return
		DB.put 'transData', {
			userRole: '1'
			targetId: @props.order?.userId
			targetRole: if @props.order?.orderType in ['GC', 'CG'] then 2 else 3
			orderNo: @props.order?.orderNo
		}
		Plugin.nav.push ['doComment']

	render: ->
		statusBtn = null
		switch parseInt(@props.order?.orderState)
			when 1
				switch parseInt(@props.order?.acceptMode)
					when 1
						statusBtn = <a onClick={@_receiver} className="u-btn02">接受</a>
					when 2
						statusBtn = <span>等待司机同意</span>
					when 3
						statusBtn = <span>等待仓库同意</span>
			when 2
				if parseInt(@props.order?.payType) is 3
					statusBtn = <a onClick={@_receiver} className="u-btn02">确认付款</a>
				else
					statusBtn = <a onClick={@_receiver} className="u-btn02">订单完成</a>
			when 3
				statusBtn = <a onClick={@_receiver} className="u-btn02">订单完成</a>
			when 4
				if not @props.order?.mjRateflag
					if @props.order?.orderType in ['GC', 'CG']
						statusBtn = <a onClick={@_receiver} className="u-btn02">评价司机</a>
					else
						statusBtn = <a onClick={@_receiver} className="u-btn02">评价仓库</a>
				else
					statusBtn = <span>订单已评价</span>

		<div className="g-item-dirver">
			<div className="g-dirver">					
				<div className="g-dirver-pic">
					<XeImage src={@props.order.userHeadPic} size="130x130" type="avatar" />
				</div>
				<div className="g-dirver-msg">
					<div className="g-dirver-name">
						<span>{@props.order?.userName}</span>
					</div>
					<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
				</div>
				<div className="g-dirver-btn">
					{statusBtn}			
				</div>
			</div>
		</div>
}

module.exports = OrderDriverCell