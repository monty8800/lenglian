require 'majia-style'
require 'index-style'
$ = require 'zepto'
fastClick = require 'fastclick'

Constants = require 'constants/constants'
DB = require 'util/storage'

if Constants.debug
	console.log 'debug mode, clear localstorage'
	DB.clear()

document.addEventListener 'deviceready', ->
	$ ->
		fastClick.attach document.body
	, false