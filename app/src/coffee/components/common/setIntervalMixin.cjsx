SetIntervalMixin = {
	componentWillMount: ->
		@intervals = []

	setInterval: ->
		@intervals.push setInterval.apply(null, arguments)

	clearInterval: ->
		@intervals.map clearInterval

	componentWillUnmount: ->
		@clearInterval()
}

module.exports = SetIntervalMixin