React = require 'react/addons'
Image = require 'util/image'


XeImage = React.createClass {
	_getDefault: ->
		if @props.type is 'avatar' then Image.avatar else Image.default
	_pic404: ->
		@setState {
			imgUrl: @_getDefault()
		}
	getInitialState: ->
		{
			imgUrl: if @props.src then Image.getFullPath(@props.src, @props.size) else @_getDefault()
		}
	componentWillReceiveProps: (nextProps)->
		console.log 'nextProps---', nextProps
		@setState {
			imgUrl: if nextProps.src then Image.getFullPath(nextProps.src, nextProps.size) else @_getDefault()
		}
	render: ->
		console.log 'img url-------', @state.imgUrl
		<img src={@state.imgUrl} onError={@_pic404} />
}

module.exports = XeImage