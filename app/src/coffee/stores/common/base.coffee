EventEmitter = require('events').EventEmitter
assign = require 'object-assign'

CHANGE_EVENT = 'change'
 


BaseStore = assign {}, EventEmitter.prototype, {
	emitChange: ->
		@emit CHANGE_EVENT

	addChangeListener: (cb)->
		@on CHANGE_EVENT, cb

	removeChangeListener: (cb)->
		@removeListener CHANGE_EVENT, cb
	}

module.exports = BaseStore