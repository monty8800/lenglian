React = require 'react/addons'
Helper = require 'util/helper'


InfoList = React.createClass {
	render: ->
		<div className="g-item g-item-des">
			<p>货物描述 : <span>冷鲜肉</span><span>冷藏</span><span>20吨</span></p>
			<p>装车时间 : <span>2015-9-1到2015-9-3</span></p>
			<p>货主给出的基础价 : <span>2000元</span></p>
		</div>
}

module.exports = InfoList