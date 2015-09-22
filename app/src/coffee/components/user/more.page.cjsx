require 'components/common/common'
require 'index-style'

React = require 'react/addons'
Plugin = require 'util/plugin'
DB = require 'util/storage'
UserStore = require 'stores/user/user' #需要用到updateuser
Auth = require 'util/auth'


More = React.createClass {
	_goPage: (page, transData)->
		DB.put 'transData', transData or {}
		Auth.needLogin ->
			Plugin.nav.push [page]
	_logout: ->
		Plugin.alert '确定要退出登录?', '提醒', (index)->
			console.log 'click index', index
			if index is 1
				DB.remove 'user'
				Plugin.nav.pop()
				Plugin.toast.success '成功退出登录!'
		, ['退出登录', '取消']
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