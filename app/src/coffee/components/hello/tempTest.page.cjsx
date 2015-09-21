require 'components/common/common'
require 'index-style'

React = require 'react'


MoreList = React.createClass {
	render: ->
			<div>	
				<div className="m-more-div">
					<div className="m-cert-item cert01 ll-font">
						修改登录密码111
					</div>
					<div className="m-cert-item cert02 ll-font">
						修改支付密码
					</div>
					<div className="m-cert-item cert03 ll-font">
						找回支付密码
					</div>
					<div className="m-cert-item cert04 ll-font">
						关于我们
					</div>
				</div>

				
			</div>

}


React.render <MoreList />, document.getElementById('content')