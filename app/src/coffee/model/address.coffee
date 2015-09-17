Immutable = require 'immutable'

Address = Immutable.Record {
	id: null #地址id
	userId: null #用户id
}
module.exports = Address