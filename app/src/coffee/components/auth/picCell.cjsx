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
		content = null
		optional = '<br/><span>(非必填)</span>'
		if @props.url
			content = <img onError={@_pic404} src={'file://' + @props.url} />
		else
			content = <div className="m-file-btn"><div className="m-file-icon ll-font"></div><p dangerouslySetInnerHTML={{__html:@props.name + if @props.optional then optional else ''}}></p></div>
		<div className="m-file-div" onClick={@_selectPic.bind this, @props.type}>
		{content}	
		</div>
}

module.exports = PicCell