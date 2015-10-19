React = require 'react/addons'

Plugin = require 'util/plugin'

UserAction = require 'actions/user/user'

Image = require 'util/image'

PicCell = React.createClass {
	_selectPic: (type)->
		console.log 'selectable--', @props.selectable
		return null if @props.selectable is false
		console.log '_selectPic', type
		Plugin.run [8, type]

	_pic404: ->
		UserAction.clearAuthPic @props.type

	_picLoad: (e)->
		console.log 'pic onLoad', e.target

	render: ->
		content = null
		optional = '<br/><span>(非必填)</span>'
		url = Image.getFullPath @props.url, '250x250'
		console.log 'url---------', url
		if @props.url
			content = <img onLoad={@_picLoad} onError={@_pic404} src={url} />
		else
			content = <div className="m-file-btn"><div className="m-file-icon ll-font"></div><p dangerouslySetInnerHTML={{__html:@props.name + if @props.optional then optional else ''}}></p></div>
		<div className="m-file-div" onClick={@_selectPic.bind this, @props.type}>
		{content}	
		</div>
}

module.exports = PicCell