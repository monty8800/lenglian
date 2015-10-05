require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()


AddBankCardVerify = React.createClass {
	_addNewBankCard:->
		Plugin.nav.push ['addBankCard']

	render : ->
		<div>
			<div class="m-releaseitem">
				<div class="g-testCode">
					<span class="icon ll-font"></span><span>15011212563</span>
					<div class="g-dirver-btn">
						<a href="#" class="u-btn02">发送验证码</a>
					</div>
				</div>
				<div class="g-testCode">
					<span> </span>
					<span><input type="text" placeholder="请输入手机验证码"></span>
				</div>
			</div>		
			<div class="u-pay-btn">
				<a href="#" class="btn">下一步</a>
			</div>
		</div>
}
React.render <AddBankCardVerify />,document.getElementById('content')
