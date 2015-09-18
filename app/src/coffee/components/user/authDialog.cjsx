React = require 'react/addons'
Plugin = require 'util/plugin'

Dialog = React.createClass {
	_goPage: (page)->
		Plugin.nav.push [page]
	_skip: ->
		Plugin.nav.pop()
	render: ->
		<section>
		<div className="m-gray"></div>
		<div className="m-payalert">
			<div className="g-paycode g-paycode-center">
				<p >尊贵的冷链马甲用户<br/>请您进行身份选择，方便交易！<br/>我们支持多重身份！</p>
			</div>
			<ul className="g-paybtn">
				<li>
					<a onClick={@_goPage.bind this, 'auth'} className="f-pay-confirm f-pay-succ">立即认证</a>					
				</li>
				<li>
					<a onClick={@_skip} className="f-pay-cancel">跳过</a>					
				</li>
			</ul>			
		</div>
		</section>
}

module.exports = Dialog