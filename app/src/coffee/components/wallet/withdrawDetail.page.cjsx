require 'components/common/common'
require 'user-center-style'


React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'

transData = DB.get 'transData'
Moment = require 'moment'

WithdrawDetail = React.createClass {
	_done: ->
		Plugin.run [3, 'withdraw:done']
	render: ->
		<section>
		<div className="m-item01">
			<div className="g-cashTime">
				<div className="g-cashStart g-cashStart-line ll-font">
					<p>提现申请已提交</p>
					<p>{Moment().format('MM-DD    HH:MM:SS')}</p>
				</div>
				<div className="g-cashEnd g-cashEnd-line ll-font">
					<p>到账时间</p>
					<p>{Moment().add(1, 'd').format('MM-DD    HH:MM:SS')}</p>
				</div>
			</div>
		</div>
		
		<div className="m-detail-info m-nomargin">			
			<p>
				<span>{transData.cardType}</span>
				<span>{transData.bankName + ' 尾号' + transData.cardNo[-4..]}</span>
			</p>
			<p>
				<span>提现金额</span>
				<span>&yen;{transData.amount}</span>
			</p>		
		</div>
		
		<div onClick={@_done} className="u-pay-btn">
			<div className="u-pay-btn">
				<a className="btn">完成</a>
			</div>
		</div>
		</section>
}

React.render <WithdrawDetail  />, document.getElementById('content')