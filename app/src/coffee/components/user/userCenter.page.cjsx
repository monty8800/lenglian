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

XeImage = require 'components/common/xeImage'

AuthStatus = React.createClass {
	_goAuth: (auth)->
		user = @props.user
		# unAuth = (auth is 'CarAuth' and user.carStatus isnt 1) or (auth is 'WarehouseAuth' and user.warehouseStatus isnt 1) or (auth is 'GoodsAuth' and user.goodsStatus isnt 1)

		# if user?.personalGoodsStatus is 0 or user?.personalCarStatus is 0 or user?.personalWarehouseStatus or user?.enterpriseGoodsStatus is 0 or user?.enterpriseCarStatus is 0 or user?.enterpriseWarehouseStatus is 0
			# return Plugin.toast.show '有认证正在审核中，无法继续认证!'
		# if user.carStatus is 2 or user.goodsStatus is 2 or user.warehouseStatus is 2
			# return Plugin.toast.show '有认证正在审核中，无法继续认证!' if unAuth

		Auth.needLogin ->
			str = ''
			switch auth
				when 'CarAuth'
					index = 3
					if user?.personalCarStatus is 0 or user?.enterpriseCarStatus is 0
						return Plugin.toast.show '有认证正在审核中，无法继续认证!'
				when 'WarehouseAuth'
					index = 1
					if user?.personalWarehouseStatus is 0 or user?.enterpriseWarehouseStatus is 0
						return Plugin.toast.show '有认证正在审核中，无法继续认证!'
				when 'GoodsAuth'
					index = 2
					if user?.personalGoodsStatus is 0 or user?.enterpriseGoodsStatus is 0
						return Plugin.toast.show '有认证正在审核中，无法继续认证!'
			str = Helper.authResMap user, index
			console.log '--------------str:', str
			if str is undefined or str is '' or str is null
				if user.certification is 0									
					Plugin.nav.push ['auth']
				else if user.certification is 1
					Plugin.nav.push ['personal' + auth]
				else
					Plugin.nav.push ['company' + auth]
			else
				Plugin.alert str, '驳回原因', (index)->
					if index is 1
						if user.certification is 0			
							Plugin.nav.push ['auth']
						else if user.certification is 1
							Plugin.nav.push ['personal' + auth]
						else
							Plugin.nav.push ['company' + auth]
				, ['重新认证', '取消']			
				# navigator.notification.alert str, null, '驳回原因', '确定'			

	render: ->
		user = @props.user
		# statusMapper = (status)->
		# 	switch status
		# 		when 1 then return 'active01'
		# 		when 2 then return 'active02'
		# 		else return 'active03'
		# <p>{'仓库' + Helper.authStatus user.warehouseStatus}</p>
		# className={'ll-font ' + statusMapper user.warehouseStatus }
		# <p>{'货主' + Helper.authStatus user.goodsStatus}</p>
		# className={'ll-font ' + statusMapper user.goodsStatus}
		# <p>{'车主' + Helper.authStatus user.carStatus}</p>
		# className={'ll-font ' + statusMapper user.carStatus}
		<div className="g-userInfo">	
			<ul>					
				<li onClick={@_goAuth.bind this, 'WarehouseAuth'}>
					<p className={'ll-font ' + Helper.authStatusMap user, 1, true } dangerouslySetInnerHTML={{__html:'<span></span>&#xe615;'}}></p>
					<p>{'仓库' + Helper.authStatusMap user, 1}</p>
				</li>	
				<li onClick={@_goAuth.bind this, 'GoodsAuth'}>
					<p className={'ll-font ' + Helper.authStatusMap user, 2, true} dangerouslySetInnerHTML={{__html:'<span></span>&#xe61a;'}}></p>
					<p>{'货主' + Helper.authStatusMap user, 2}</p>
				</li>
				<li onClick={@_goAuth.bind this, 'CarAuth'}>
					<p className={'ll-font ' + Helper.authStatusMap user, 3, true} dangerouslySetInnerHTML={{__html: '<span></span>&#xe60e;'}}></p>
					<p>{'车主' + Helper.authStatusMap user, 3}</p>
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
					<dt className="fl" onClick={@_changeAvatar} >
						<XeImage src={user.avatar} size='130x130' type='avatar' />
					</dt>
					<dd className="fl">
						<p className="g-name">{if (user.carStatus is 1 or user.goodsStatus is 1 or user.warehouseStatus is 1) then user.company or user.name or user.mobile else user.mobile}</p>
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
					Auth.needAuth 'goods',->
						Plugin.nav.push [page]
				else if page is 'myCar'
					Auth.needAuth 'car',->
						Plugin.nav.push [page]
				else if page is 'myWarehouse'
					Auth.needAuth 'warehouse',->
						Plugin.nav.push [page]
				else
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
		console.log 'user center msg', msg
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


