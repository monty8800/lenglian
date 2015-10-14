React = require 'react'
Plugin = require 'util/plugin'
Auth = require 'util/auth'
UserStore = require 'stores/user/user'

Post = React.createClass {

	_goPage: (page)->
		Auth.needLogin ->
			user = UserStore.getUser()
			switch page
				when 'releaseCar'
					if user.carStatus isnt 1
						return Plugin.toast.err '尚未通过车主认证，请认证后再进行发布'
				when 'addGodds'
					return Plugin.toast.err '尚未通过货主认证，请认证后再进行发布' if user.goodsStatus isnt 1
				when 'releaseWarehouse'
					return Plugin.toast.err '尚未通过仓库主认证，请认证后再进行发布' if user.warehouseStatus isnt 1	
			Plugin.nav.push [page]

	render: ->
		posts = this.props.items.map (item, i)->
			cls = 'll-font nav0' + (i + 1)
			<li key={i} onClick={ @_goPage.bind this, item.page }>
				<div className={cls}></div>
				<div className="nav-text">{item.title}</div>
			</li>
		, this
		<div className="m-nav02">
			<ul className="clearfix">
				{posts}
			</ul>
		</div>
}

module.exports = Post