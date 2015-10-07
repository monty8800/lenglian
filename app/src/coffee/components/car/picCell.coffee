React = require 'react/addons'
Plugin = require 'util/plugin'

UserAction = require 'actions/user/user'

PicCell = React.createClass {

	_selectPic: (type)->
		console.log '_selectPic', type
		Plugin.run [8, type]

	_pic404: ->
		UserAction.clearAuthPic @props.type

	render: ->
		if @props.url
			content = <img onError={@_pic404} src={'file://' + @props.url} />
		else
			content = <a href="###"><span className="ll-font"></span><p dangerouslySetInnerHTML={{__html:@props.name}}></p></a>

		<li onClick={@_selectPic.bind this, @props.type}>
			{ content }
		</li>
		
}

module.exports = PicCell