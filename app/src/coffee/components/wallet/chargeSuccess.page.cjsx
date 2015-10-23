require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
Plugin = require 'util/plugin'
DB = require 'util/storage'
money = DB.get 'money'

Info = React.createClass {
	wallet: ->
		Plugin.nav.push ['myWallet']
	render: ->
		<div className="m-paysuccess">
			<div className="g-paysuccess-item01">
				<p className="ll-font">恭喜您，充值成功！</p>
			</div>
			<div className="g-paysuccess-item02">
				<p>在线支付: <i>&yen;<span>{money.toFixed 2}</span></i></p>
			</div>
			<div className="u-order-btn">
				<a href="###" onClick={@wallet}>查看我的钱包</a>
			</div>
		</div>		
}

React.render <Info />, document.getElementById('content')