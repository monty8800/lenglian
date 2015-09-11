keymirror  = require 'keymirror'

actionType = {
	APP_HELLO: null
}

api = {
	#TODO: api列表
	hello: 'http://www.baidu.com'
}

module.exports = 
	api: api
	actionType: keymirror actionType
	debug: true