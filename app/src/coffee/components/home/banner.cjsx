BannerPic = require 'banner'

React = require 'react'

Banner = React.createClass {
	render: ->
		<div className="m-swiper">
			<img src={BannerPic} height=360 width=640 />
		</div>
}

module.exports = Banner