React = require 'react/addons'

Constants = require 'constants/constants'

SelectionAction = require 'actions/common/selection'
SelectionStore = require 'stores/common/selection'

Selection = React.createClass {
	_handleChange: (option, e)->
		console.log 'option---', option, 'event ----', e
		key = option.key
		newState = Object.create @state
		index = newState.checkedList.indexOf key
		if index is -1
			newState.checkedList.push key
		else
			newState.checkedList.splice index, 1
		
		newState.all = newState.checkedList.length is @props.selectionMap.options.length
		if newState.all
			newState.text = '全部'
		else
			#取前4个显示
			newState.text = (option.value for option in @props.selectionMap.options when option.key in newState.checkedList[0..3]).join ','
		@setState newState
		SelectionAction.updateSelection @props.selectionMap.key, newState.checkedList

	_handleAll: (e)->
		console.log 'all event---', e
		newState = Object.create @state
		newState.all = e.target.checked
		if newState.all
			newState.checkedList = (option.key for option in @props.selectionMap.options)
		else
			newState.checkedList = []
		newState.text = '全部'
		
		@setState newState

	_open: ->
		newState = Object.create @state
		newState.open = not @state.open
		@setState newState

	getInitialState: ->
		initState = {
			text: '全部'
			open: false
			all: true
			checkedList: []
		}
		#初始化就全选
		for option in @props.selectionMap.options
			initState.checkedList.push option.key

		console.log 'init state', initState
		return initState

	render: ->
		console.log 'option', @props.selectionMap
		options = @props.selectionMap.options.map (option, i)->
			<label className="u-label"><input checked={option.key in @state.checkedList} onChange={@_handleChange.bind this, option} className="ll-font" type="checkbox" /><div>{option.value}</div></label>
		, this
		cls = "g-div01 ll-font u-arrow-right"
		<li>
			<div onClick={@_open} className={if @state.open then cls + ' g-div01-act' else cls} dangerouslySetInnerHTML={{__html: @props.selectionMap.value + "<span>" + @state.text + "</span>"}}>		
			</div>
			<div className="g-div02" style={{display: if @state.open then 'block' else 'none'}}>
				<div className="g-div02-item">
					<label className="u-label" >
						<input checked={@state.all} onChange={@_handleAll} className="ll-font" type="checkbox" /><div>全部</div>
					</label>
					{options}
				</div>
			</div>
		</li>
}

module.exports = Selection