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
		nrequest = [
			{title: '我要找车', page: 'foundCar'},
			{title: '我要找仓库', page: 'foundCar'},
			{title: '司机找货', page: 'foundCar'},
			{title: '仓库找货', page: 'foundCar'}
		]
		# requests = ['我要找车', '我要找仓库', '司机找货', '仓库找货']
		nposts = [
			{title: '发布车源', page: 'addCar'},
			{title: '发布货源', page: 'addCar'},
			{title: '发布库源', page: 'addCar'}
		]
		# posts = ['发布车源', '发布货源', '发布库源']
		console.log 'nrequest ----- ', nrequest
		<section>
		<Banner />
		<Request items={nrequest} />
		<Post items={nposts} />
		</section>
}

React.render <Home  />, document.getElementById('content')

