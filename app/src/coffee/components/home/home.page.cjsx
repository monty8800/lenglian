require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
Banner = require 'components/home/banner'
Request = require 'components/home/request'
Post = require 'components/home/post'

Home = React.createClass {
	mixins: [PureRenderMixin]

	getInitialState: ->
		null

	componentDidMount: ->
		console.log 'mount'

	componentWillUnmount: ->
		console.log 'unmount'

	_onChange: ->
		console.log 'change'

	render: ->
		requests = ['我要找车', '我要找仓库', '司机找货', '仓库找货']
		posts = ['发布车源', '发布货源', '发布库源']
		<section>
		<Banner />
		<Request items={requests} />
		<Post items={posts} />
		</section>
}

React.render <Home  />, document.getElementById('content')