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
						<p className="g-name">{user.name || user.company || user.mobile}</p>
						<p>成交数：<span>45单</span></p>
					</dd>
				</dl>
			</div>
			<div className="g-userInfo">
				<ul>
					<li>
						<p className="active01 ll-font" dangerouslySetInnerHTML={{__html:'<span></span>&#xe615;'}}></p>
						<p>仓库已认证</p>
					</li>
					<li>
						<p className="active02 ll-font" dangerouslySetInnerHTML={{__html:'<span></span>&#xe61a;'}}></p>
						<p>货源认证中</p>
					</li>
					<li>
						<p className="active03 ll-font"><span></span>&#xe60e;</p>
						<p>车源已认证</p>
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


