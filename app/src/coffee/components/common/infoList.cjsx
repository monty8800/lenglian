React = require 'react/addons'
Helper = require 'util/helper'


InfoList = React.createClass {
	render: ->
		<div className="g-item g-item-des">
			<p>货物描述 : <span>{@props.goods.name}</span><span>{Helper.goodsType @props.goods.type}</span><span>{@props.goods.weight + '吨'}</span></p>
			<p>装车时间 : <span>{@props.goods?.installMinTime?[0..9] + '到' + @props.goods?.installMaxTime?[0..9]}</span></p>
			<p>货主给出的基础价 : <span>{@props.goods.price + '元'}</span></p>
		</div>
}

module.exports = InfoList