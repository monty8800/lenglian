Immutable = require 'immutable'

Address = require 'model/address'

Goods = Immutable.Record {
	id: null #货源id
	name: null #货物名称
}

module.exports = Goods