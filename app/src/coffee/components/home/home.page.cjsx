require 'components/common/common'

React = require 'react'

Home = React.createClass {
	getInitialState: ->
		console.log 'init'
		return null

	componentDidMount: ->
		console.log 'mount'

	componentWillUnmount: ->
		console.log 'unmount'

	_onChange: ->
		console.log 'change'

	render: ->
		<div className="m-swiper">
			<img src="../images/banner.jpg" height="360" width="640">
		</div>

		<div className="m-nav">
			<ul className="clearfix">
				<li>
					<div className="ll-font nav01"></div>
					<div className="nav-text">我要找车</div>
				</li>
				<li>
					<div className="ll-font nav02"></div>
					<div className="nav-text">我要找仓库</div>
				</li>
				<li>
					<div className="ll-font nav03"></div>
					<div className="nav-text">司机找货</div>
				</li>
				<li>
					<div className="ll-font nav04"></div>
					<div className="nav-text">仓库找货</div>
				</li>
			</ul>
		</div>

		<div className="m-nav02">
			<ul className="clearfix">
				<li>
					<div className="ll-font nav01"></div>
					<div className="nav-text">发布车源</div>
				</li>
				<li>
					<div className="ll-font nav02"></div>
					<div className="nav-text">发布货源</div>
				</li>
				<li>
					<div className="ll-font nav03"></div>
					<div className="nav-text">发布库源</div>
				</li>
			</ul>
		</div>
}

React.render <Home  />, document.getElementById('content')