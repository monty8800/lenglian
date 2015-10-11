React = require 'react'

XeImage = require 'components/common/xeImage'

#TODO: 评分
OrderDriverCell = React.createClass {
	_receiver: ->
		console.log 'click recive!'

	_getBtnTitle: ->
		switch parseInt(@props.order?.orderState)
			when 1 then '接受'
			when 2 then '确认付款'
			when 3 then '订单完成'
			when 4
				if parseInt(@props.order?.acceptMode) is 2 then '评价司机' else '评价仓库'
	render: ->
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
					{
						switch parseInt(@props.order?.acceptMode)
							when 1
								<a onClick={@_receiver} className="u-btn02">{@_getBtnTitle()}</a>
							when 2
								<span>等待司机同意</span>
							when 3
								<span>等待仓库同意</span>
					}			
				</div>
			</div>
		</div>
}

module.exports = OrderDriverCell