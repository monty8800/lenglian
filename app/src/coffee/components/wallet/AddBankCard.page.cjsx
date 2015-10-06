require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()


AddBankCard = React.createClass {
	_addNewBankNext:->
		Plugin.nav.push ['addBankCardNext']

	render : ->
		<div>
			<div className="g-bankCard">
				请绑定持卡人本人的银行卡
			</div>
			
			<div className="m-releaseitem">
				<div>
					<span>持卡人: </span><span>林夕</span>
				</div>
				<div className="u-personIcon u-close ll-font">
					<span>卡&nbsp;&nbsp;&nbsp;号: </span><span>13412356854</span>
				</div>
			</div>
			
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a onClick={ @_addNewBankNext } href="#" className="btn">下一步</a>

				</div>
			</div>
			<div className="u-green ll-font">
				同意
				<a href="#">《马甲协议》</a>
			</div>
		</div>
}
React.render <AddBankCard />,document.getElementById('content')

