require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()


AddBankCardNext = React.createClass {
	_addNewBankCard:->
		Plugin.nav.push ['addBankCard']

	render : ->
		<div>
			<div className="m-releaseitem">
				<div>
					<span>卡类型: </span><span>中国建设银行卡</span><span>储蓄卡</span>
				</div>
				<div>
					<label htmlFor="packType"><span>开户行:</span></label>
					<input type="text" placeholder="请输入开户行" id="packType"/>
				</div>
				<div>
					<label htmlFor="packType"><span>手机号:</span></label>
					<input type="text" placeholder="银行预留手机号码" id="packType"/>
				</div>
			</div>
			<div className="u-pay-btn">
				<a href="#" className="btn noUse">下一步</a>
			</div>
			<div className="u-green ll-font">
				同意
				<a href="#">《马甲协议》</a>
			</div>
		</div>
}
React.render <AddBankCardNext />,document.getElementById('content')

