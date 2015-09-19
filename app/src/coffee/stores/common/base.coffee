EventEmitter = require('events').EventEmitter
assign = require 'object-assign'
DB = require 'util/storage'

CHANGE_EVENT = 'change'
 


BaseStore = assign {}, EventEmitter.prototype, {
	emitChange: (params)->
		@emit CHANGE_EVENT, params

	addChangeListener: (cb)->
		@on CHANGE_EVENT, cb

	removeChangeListener: (cb)->
		@removeListener CHANGE_EVENT, cb
	}

module.exports = BaseStore