React = require 'react/addons'

NoResult = React.createClass {
	render: ->
		console.log '-------props.:'
		<div style={{display: if @props.isShow is true then 'block' else 'none'}} className="m-searchNoresult">
			<div className="g-bgPic"></div>
			<p className="g-txt">很抱歉，没能找到您要的结果</p>
		</div>
}

module.exports = NoResult