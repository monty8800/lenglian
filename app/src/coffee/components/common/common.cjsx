require 'majia-style'

fastClick = require 'fastclick'

Constants = require 'constants/constants'
DB = require 'util/storage'

if Constants.debug
	console.log 'debug mode, clear localstorage'
	# TODO
	# DB.clear()

document.addEventListener 'deviceready', ->
	fastClick.attach document.body
	DB.put 'uuid', window.uuid if window.uuid
	DB.put 'version', window.version if window.version
	DB.put 'client_type', window.client_type if window.client_type