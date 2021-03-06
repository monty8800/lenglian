require 'majia-style'
require 'anim-style'

fastClick = require 'fastclick'

Constants = require 'constants/constants'
DB = require 'util/storage'
CommonAction = require 'actions/common/common'

if Constants.debug
	console.log 'debug mode, clear localstorage'
	# TODO
	# DB.clear()

document.addEventListener 'deviceready', ->
	fastClick.attach document.body
	DB.put 'uuid', window.uuid if window.uuid
	DB.put 'version', window.version if window.version
	DB.put 'client_type', window.client_type if window.client_type


document.addEventListener 'visibilitychange', ->
	console.log '----------', document.visibilityState
	CommonAction.updateStore() if document.visibilityState is 'visible'
	
	
