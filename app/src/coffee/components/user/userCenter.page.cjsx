require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'
Plugin = require 'util/plugin'

Auth = require 'util/auth'

Helper = require 'util/helper'

Image = require 'util/image'

AuthStatus = React.createClass {
	_goAuth: (auth)->
		user = @props.user
		if user.carStatus is 2 or user.goodsStatus is 2 or user.warehouseStatus is 2
			Plugin.toast.show '有认证正在审核中，无法继续认证!'
			return
		Auth.needLogin ->
			switch auth
				when 'CarAuth'
					return null if user.carStatus in [1, 2]
				when 'WarehouseAuth'
					return null if user.warehouseStatus in [1, 2]
				when 'GoodsAuth'
					return null if user.goodsStatus in [1, 2]

			if user.certification is 0
				Plugin.nav.push ['auth']
			else if user.certification is 1
				Plugin.nav.push ['personal' + auth]
			else
				Plugin.nav.push ['company' + auth]

	render: ->
		user = @props.user
		statusMapper = (status)->
			switch status
				when 1 then return 'active01'
				when 2 then return 'active02'
				else return 'active03'
		<div className="g-userInfo">
			<ul>
				<li onClick={@_goAuth.bind this, 'WarehouseAuth'}>
					<p className={'ll-font ' + statusMapper user.warehouseStatus } dangerouslySetInnerHTML={{__html:'<span></span>&#xe615;'}}></p>
					<p>{'仓库' + Helper.authStatus user.warehouseStatus}</p>
				</li>
				<li onClick={@_goAuth.bind this, 'GoodsAuth'}>
					<p className={'ll-font ' + statusMapper user.goodsStatus} dangerouslySetInnerHTML={{__html:'<span></span>&#xe61a;'}}></p>
					<p>{'货源' + Helper.authStatus user.goodsStatus}</p>
				</li>
				<li onClick={@_goAuth.bind this, 'CarAuth'}>
					<p className={'ll-font ' + statusMapper user.carStatus} dangerouslySetInnerHTML={{__html: '<span></span>&#xe60e;'}}></p>
					<p>{'车源' + Helper.authStatus user.carStatus}</p>
				</li>
			</ul>
		</div>
}

Profile = React.createClass {
	#TODO: 用户头像
	_changeAvatar: ->
		Auth.needLogin ->
			Plugin.run [8, 'avatar']

	_pic404: ->
		UserAction.clearAuthPic 'avatar'

	render: ->
		user = this.props.user
		console.log 'user is', user
		<div className="m-userCenter-top">
			<div className="g-userPrivate">
				<dl className="clearfix"> 
					<dt className="fl">
						<img onError={@_pic404} onClick={@_changeAvatar} src={Image.getFullPath(user.avatar, '130x130') or Image.avatar}/>
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
		user = UserStore.getUser()
		console.log 'go page', page
		if page in ['more']
			Plugin.nav.push [page]
		else
			Auth.needLogin ->
				if page is 'myGoods'
					if user.goodsStatus isnt 1
						return Plugin.toast.err '尚未通过货主认证，请认证后再进行操作' 
				else if page is 'myCar'
					if user.carStatus isnt 1
						return Plugin.toast.err '尚未通过车主认证，请认证后再进行操作'
				else if page is 'myWarehouse'
					if user.warehouseStatus isnt 1
						return Plugin.toast.err '尚未通过仓库主认证，请认证后再进行操作'
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

	_onChange: (msg)->
		@setState {
			user: UserStore.getUser()
			menus: UserStore.getMenus()
		}

	render: ->
		console.log 'user', @state.user
		menus = this.state.menus.map (menu, i)->
			<Menu items={menu} key={i} />

		<div>
			<Profile user={this.state.user} />
			{menus}
		</div>
}

React.render <UserCenter  />, document.getElementById('content')


