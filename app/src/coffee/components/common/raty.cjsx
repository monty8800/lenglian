React = require 'react/addons'
RatyAction = require 'actions/common/raty'


Raty = React.createClass {
	getInitialState: ->
		{
			ratyScore: Math.min(Math.max(0, @props.score), 10)
			dirty: false
		}

	_computeRate: (x, starWidth)->
		score = Math.floor(x / starWidth) * 2
		if x % starWidth > starWidth / 2
			score += 2
		else
			score += 1
		@setState {
			ratyScore: Math.min(Math.max(score, 0), 10)
		}

	_move: (e)->
		ne = e.touches[0]
		console.log 'moving', ne
		@_computeRate ne.clientX, ne.target.offsetWidth

	_click: (e)->
		ne = e.nativeEvent
		@_computeRate ne.offsetX, ne.target.offsetWidth
		@_submit()

	_submit: ->
		@setState {
			dirty: true
		}

	componentDidUpdate: ->
		if @state.dirty
			RatyAction.rate @state.ratyScore
			@setState {
				dirty : false
			}

	componentWillReceiveProps: (nextProps)->
		@setState {
			ratyScore: Math.min(Math.max(0, nextProps.score), 10)
			dirty: false
		}

	render: ->
		starCount = Math.floor(@state.ratyScore / 2)
		hasHalf = (@state.ratyScore % 2) isnt 0
		content = ('&#xe609;' for i in [0...starCount])
		content.push '&#xe631;' if hasHalf
		if content.length < 5
			content.push '&#xe62f;' for j in [0...5-content.length]

		console.log 'content', content

		if @props.canRate
			<p className="star">
				{
					for star, index in content
						<i onTouchEnd={@_submit} onTouchMove={@_move} onClick={@_click} key={index} style={color: if star is '&#xe62f;' then '#666' else '#fd8c2a'} className="ll-font" dangerouslySetInnerHTML={{__html: star}}></i>
				}
			</p>
		else
			<em dangerouslySetInnerHTML={{__html: content.join('')}}>
			</em>
}

module.exports = Raty
