Constants = require 'constants/constants'
xePlugin = null
if not Constants.inBrowser
	xePlugin = xe
else
	push = (args)->
		window.location.href = "/webpack-dev-server/#{args[0]}.html"
	pop = ->
		window.history.back()
	popTo = (index)->
		window.history.go(-index-1)
	xePlugin = {
		nav: {
			push: push
			pop: pop
			popTo: popTo
		}
		toast: {
			show: (msg)->
				alert msg
			success: (msg)->
				alert msg
			err: (msg)->
				alert msg
		}
		loading: {
			show: (msg)->
				alert 'show loading', msg
			hide: ->
				alert 'hide loading'
		}
	}

module.exports = xePlugin