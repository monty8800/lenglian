# 添加车辆筛选条件
React = require 'react/addons'
CarAction = require 'actions/car/car'


Selection = React.createClass {

	_open: ->
		newState = Object.create @state
		newState.open = not @state.open
		@setState newState

	_change: (item)->
		type = ''
		if @props.items.key is 'carType'
			type = 'carType'
		else if @props.items.key is 'carCategory'
			type = 'carCategory'
		else if @props.items.key is 'weight'
			type = 'weight'
		else if @props.items.key is 'carLength'
			type = 'carLength'

		index = @props.items.options.indexOf item

		CarAction.AddCarSelection([type, index])

		newState = Object.create @state
		newState.open = not @state.open
		newState.title = item.value
		@setState newState		

	getInitialState: ->
		{
			title: '全部'
			open: false
			checkValue: 0
		}

	render: ->

		options = @props.items.options.map (item, i)->
			<label className="u-label"><input name="a" onChange={@_change.bind this, item} className="ll-font" type="radio"/><div>{item.value}</div></label>
		, this
		<li>
			<div onClick={@_open} className={ if @state.open then "g-div01 ll-font u-arrow-right g-div01-act" else 'g-div01 ll-font u-arrow-right'} 
				dangerouslySetInnerHTML={{__html: @props.items.value + '<span>' + @state.title + '</span>'}}>
			</div>
			<div className="g-div02" style={{display: if @state.open then 'block' else 'none'}}>
				<div className="g-div02-item">
					{options}
				</div>
			</div>
		</li>
				
}

module.exports = Selection