require 'components/common/common'
require 'index-style'

React = require 'react/addons'
Plugin = require 'util/plugin'
DB = require 'util/storage'

More = React.createClass {
	_goPage: (page, transData)->
		DB.put 'transData', transData or {}
		Plugin.needLogin ->
			Plugin.nav.push [page]
	_logout: ->
		DB.remove 'user'
		Plugin.alert '成功退出登录'
		Plugin.nav.pop()
	render: ->
		<section>
		<div className="m-more-div">
			<div className="m-cert-item cert01 ll-font" onClick={@_goPage.bind this, 'changePasswd', {type: 'pwd'}}>
				修改登录密码
			</div>
			<div className="m-cert-item cert02 ll-font" onClick={@_goPage.bind this, 'changePasswd', {type:'payPwd'}}>
				修改支付密码
			</div>
			<div className="m-cert-item cert03 ll-font" onClick={@_goPage.bind this, 'resetPasswd', {type:'payPwd'}}>
				找回支付密码
			</div>
			<div className="m-cert-item cert04 ll-font">
				关于我们
			</div>
		</div>

		<div className="m-quit" onClick={@_logout}>
			退出登录
		</div>
		</section>
}

React.render <More />, document.getElementById('content')