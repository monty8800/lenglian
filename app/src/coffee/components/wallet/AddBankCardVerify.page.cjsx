require 'components/common/common'
require 'user-center-style'
require 'majia-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()


AddBankCardVerify = React.createClass {
	_verifyNext:->
		Plugin.toast.show 'VerifyNext'

	render : ->
		<div>
			<div className="m-releaseitem">
				<div className="g-testCode">
					<span className="icon ll-font"></span><span>15011212563</span>
					<div className="g-dirver-btn">
						<a href="#" className="u-btn02">发送验证码</a>
					</div>
				</div>
				<div className="g-testCode">
					<span> </span>
					<span><input type="text" placeholder="请输入手机验证码"/></span>
				</div>
			</div>		
			<div className="u-pay-btn">
				<a onClick={ @_verifyNext } href="#" className="btn">下一步</a>
			</div>
		</div>
}
React.render <AddBankCardVerify />,document.getElementById('content')
