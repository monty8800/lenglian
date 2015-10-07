require 'components/common/common'
require 'user-center-style'


React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'

bankPic = require 'pay-bank-01'

WithdrawDetail = React.createClass {
	render: ->
		<section>
		<div className="m-item01">
			<div className="g-cashTime">
				<div className="g-cashStart g-cashStart-line ll-font">
					<p>提现申请已提交</p>
					<p>09-22  16:33:00</p>
				</div>
				<div className="g-cashEnd g-cashEnd-line ll-font">
					<p>到账时间</p>
					<p>09-22  16:33:00</p>
				</div>
			</div>
		</div>
		
		<div className="m-detail-info m-nomargin">			
			<p>
				<span>储蓄卡</span>
				<span>招商银行 尾号2384</span>
			</p>
			<p>
				<span>提现金额</span>
				<span>&yen;5.00</span>
			</p>		
		</div>
		
		<div className="u-pay-btn">
			<div className="u-pay-btn">
				<a className="btn">完成</a>
			</div>
		</div>
		</section>
}

React.render <WithdrawDetail  />, document.getElementById('content')