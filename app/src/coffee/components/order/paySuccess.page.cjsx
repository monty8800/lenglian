require 'components/common/common'
React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

Plugin = require 'util/plugin'
Constants = require 'constants/constants'
DB = require 'util/storage'

transData = DB.get 'transData2'
DB.remove 'transData2'
PaySuccess = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	_goOrderList: ->
		Plugin.run [3, 'go:order:list']
	render: ->
		<div className="m-paysuccess">
			<div className="g-paysuccess-item01">
				<p className="ll-font">恭喜您， 支付成功！</p>
				<p>我们会尽快通知车主为您发货！</p>
			</div>
			<div className="g-paysuccess-item02">
				<p>订单编号: <span>{transData.orderNo or ''}</span></p>
				<p>在线支付: <i>&yen;<span>{transData.payAmount or ''}</span></i></p>
			</div>
			<div className="u-order-btn">
				<a onClick={@_goOrderList}>查看订单列表</a>
			</div>
		</div>
}

React.render <PaySuccess />,document.getElementById('content')