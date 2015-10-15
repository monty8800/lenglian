require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'
AuthCheck = require 'util/auth'

Auth = React.createClass {
	mixin: [PureRenderMixin]
	_goAuth: (authName)->
		switch authName
			when 'GoodsAuth'
				return null if @state.user.goodsStatus in [1, 2]
			when 'CarAuth'
				return null if @state.user.carStatus in [1, 2]
			when 'WarehouseAuth'
				return null if @state.user.warehouseStatus in [1, 2]

		type = @state.type

		AuthCheck.needLogin ->
			Plugin.nav.push [type + authName]
	_changeType: (type)->
		if @state.user.certification isnt 0
			return
		@setState {
			type: type
			user: @state.user
		}
	getInitialState: ->
		user = UserStore.getUser()
		{
			type: if user.certification isnt 2 then 'personal' else 'company'
			user: user
		}
	render: ->
		console.log 'user', @state.user
		mapStatus = (status)->
			switch status
				when 1 then '已认证'
				when 2 then '认证中'
				else ''
		<section>
		<div className="m-tab01">
			<ul>
				<li onClick={@_changeType.bind this, 'personal'} className={if @state.type is 'personal' then "rightLine" else null}><span className={if @state.type is 'personal' then "active" else null}>个人认证</span></li>
				<li onClick={@_changeType.bind this, 'company'} className={if @state.type is 'company' then 'rightLine' else null}><span className={if @state.type is 'company' then "active" else null}>公司认证</span></li>
			</ul>
		</div>
		<div>
			<div onClick={@_goAuth.bind this, 'GoodsAuth'} className="m-cert-item ll-font clearfix">
				<div className="g-certIcon fl ll-font cert01"></div>
				<dl className="g-certCont fl">
					<dt className={'clearfix ' + if @state.user.goodsStatus in [1, 2] then 'active' else ''}>
						<p className="fl">我是货主</p>
						<span className="fl">
							{mapStatus @state.user.goodsStatus}
						</span>
					</dt>
					<dd>您可以免费发布货物运输信息，线路信息，免费查询车辆信息，仓库信息。</dd>
				</dl>
			</div>
			<div onClick={@_goAuth.bind this, 'CarAuth'} className="m-cert-item ll-font clearfix">
				<div className="g-certIcon fl ll-font cert02"></div>
				<dl className="g-certCont fl">
					<dt className={'clearfix ' + if @state.user.carStatus in [1, 2] then 'active' else ''}><p className="fl">我是司机</p><span className="fl">{mapStatus @state.user.carStatus}</span></dt>
					<dd>您可以免费发布车辆信息，免费查询货物信息，随时查看附近货物。</dd>
				</dl>
			</div>
			<div onClick={@_goAuth.bind this, 'WarehouseAuth'} className="m-cert-item ll-font clearfix">
				<div className="g-certIcon fl ll-font cert03"></div>
				<dl className="g-certCont fl">
					<dt className={'clearfix ' + if @state.user.warehouseStatus in [1, 2] then 'active' else ''}><p className="fl">我是仓库主</p><span className="fl">{mapStatus @state.user.warehouseStatus}</span></dt>
					<dd>您可以免费发布车辆信息，免费查询货物信息，随时查看附近货物。</dd>
				</dl>
			</div>
		</div>
		<div className="cert-msg">
			<h4>认证须知</h4>
			<p>1. 如果您是多重身份的用户，请进行不同角色的认证，这样方便您的订单交易。</p>
			<p>2. 未认证您可以查看货物，司机，仓库，但不可以进行抢单，竞价，选择司机，选择仓库。</p>
			<p>3. 认证后您可以在本平台进行订单交易。</p>
			<h5>为了方便您的订单交易请您尽早进行认证！</h5>
		</div>
		</section>
}

React.render <Auth />, document.getElementById('content')