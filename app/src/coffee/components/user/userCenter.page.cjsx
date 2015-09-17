require 'components/common/common'
require 'user-center-style'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

userPic = require 'userPic.jpg'

UserStore = require 'stores/user/user'
UserAction = require 'actions/user/user'


Profile = React.createClass {
	render: ->
		user = this.props.user
		<div className="m-userCenter-top">
			<div className="g-userPrivate">
				<dl className="clearfix">
					<dt className="fl">
						<img src={userPic}/>
					</dt>
					<dd className="fl">
						<ul>
							<li>
								<span className="ll-font">{user.name || user.company || user.mobile}</span>
							</li>
							<li className="clearfix">
								<p className="ll-font">&#xe615;</p>
								<p className="ll-font">&#xe61a;</p>
								<p className="ll-font">&#xe60e;</p>
							</li>
						</ul>
					</dd>
				</dl>
			</div>
			<div className="g-userInfo">
				<ul>
					<li>
						<p>{user.orderDoneCount}单</p>
						<p>成交数</p>
					</li>
					<li>
						<p>{user.orderBreakCount}单</p>
						<p>违约数</p>
					</li>
				</ul>
			</div>
		</div>
}

Menu = React.createClass {
	render: ->
		items = this.props.items.map (item, i)->
			menu = item.toJS()
			cls = "ll-font u-arrow-right " + menu.cls
			<div className={cls} key={i}>{menu.title}</div>

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


