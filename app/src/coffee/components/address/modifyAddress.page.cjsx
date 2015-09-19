require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

Address = React.createClass {
	render: ->
		<div>
			<div className="m-adr-ed">
				<ul>
					<li className="adr-ed-fir">
						<span>选择地区</span>
						<input type="text" placeholder="请选择地区" />
						<em>点击修改</em>
					</li>
					<li>
						<span>详细地址</span>
						<textarea name="">北京市海淀区泰鹏大厦</textarea>
					</li>
				</ul>
			</div>
			<div className="m-adr-btn">
				<a href="#">地图上定位</a>
			</div>
		</div>
}	

React.render <Address />, document.getElementById('content')