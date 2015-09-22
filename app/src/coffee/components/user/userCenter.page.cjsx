require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

userPic = require 'userPic.jpg'

UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'

Auth = require 'util/auth'

AuthStatus = React.createClass {
	render: ->
		user = @props.user
		statusMapper = (status)->
			switch status
				when 1 then return 'active01'
				when 2 then return 'active02'
				else return 'active03'
		<div className="g-userInfo">
			<ul>
				<li>
					<p className={'ll-font ' + statusMapper user.warehouseStatus } dangerouslySetInnerHTML={{__html:'<span></span>&#xe615;'}}></p>
					<p>仓库已认证</p>
				</li>
				<li>
					<p className={'ll-font ' + statusMapper user.goodsStatus} dangerouslySetInnerHTML={{__html:'<span></span>&#xe61a;'}}></p>
					<p>货源认证中</p>
				</li>
				<li>
					<p className={'ll-font ' + statusMapper user.carStatus} dangerouslySetInnerHTML={{__html: '<span></span>&#xe60e;'}}></p>
					<p>车源已认证</p>
				</li>
			</ul>
		</div>
}

Profile = React.createClass {
	#TODO: 用户头像
	render: ->
		user = this.props.user
		console.log 'user is', user
		<div className="m-userCenter-top">
			<div className="g-userPrivate">
				<dl className="clearfix"> 
					<dt className="fl">
						<img src={userPic}/>
					</dt>
					<dd className="fl">
						<p className="g-name">{user.name || user.company || user.mobile}</p>
						<p>成交数：<span>{user.orderDoneCount}单</span></p>
					</dd>
				</dl> 
			</div>
			<AuthStatus user=@props.user />
		</div>
}

Menu = React.createClass {    
	_goPage: (page)->
		console.log 'go page', page
		if page in ['more']
			Plugin.nav.push [page]
		else
			Auth.needLogin ->
				Plugin.nav.push [page]
	render: ->
		items = this.props.items.map (item, i)->
			console.log 'this', this
			menu = item.toJS()
			cls = "ll-font u-arrow-right " + menu.cls
			<div className={cls} key={i}  onClick={@_goPage.bind this, menu.url}>{menu.title}</div>
		, this

		<div className="m-userItem">
			{items}
		</div>
}

UserCenter = React.createClass {
	minxins: [PureRenderMixin]
	getInitialState: ->
		{
			user: UserStore.getUser()
			menus: UserStore.getMenus()
		}
	componentDidMount: ->
		UserStore.addChangeListener @_onChange
		UserAction.info()

	componentWillUnmount: ->
		UserStore.removeChangeListener @_onChange

	_onChange: ->
		@setState {
			user: UserStore.getUser()
			menus: UserStore.getMenus()
		}

	render: ->
		menus = this.state.menus.map (menu)->
			<Menu items={menu}  />

		<div>
			<Profile user={this.state.user} />
			{menus}
		</div>
}

React.render <UserCenter  />, document.getElementById('content')


