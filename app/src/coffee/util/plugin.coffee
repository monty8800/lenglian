Constants = require 'constants/constants'


xePlugin = null
if not Constants.inBrowser
	exec = window.cordova.require 'cordova/exec' 

	push = (args)->
		console.log 'push', args
		args.splice 0, 0, '1'
		exec null, null, 'XEPlugin', 'normalCommand', args

	pop = ()->
		exec null, null, 'XEPlugin', 'normalCommand', ['2']

	popTo = (index)->
		exec null, null, 'XEPlugin', 'normalCommand', ['2', index]

	nav = {
		push: push
		pop: pop
		popTo: popTo
	}

	run = (args, success, err)->
		exec success, err, 'XEPlugin', 'normalCommand', args

	xeAlert = (message, title, cb, btns)->
		navigator.notification.confirm message, cb or null, title or '提示', btns or ['确定', '取消']

	showToast = (message, time, position)->
		args = ['show', message]
		args.push time if time
		args.push position if position
		exec null, null, 'XEPlugin', 'toast', args

	successToast = (message)->
		exec null, null, 'XEPlugin', 'toast', ['success', message]

	errToast = (message)->
		exec null, null, 'XEPlugin', 'toast', ['error', message]

	toast = {
		show: showToast
		success: successToast
		err: errToast
	}

	showLoading = (message, force)->
		args = ['show', message]
		force = if force is undefined then true else force
		args.push force
		exec null, null, 'XEPlugin', 'loading', args

	hideLoading = ->
		exec null, null, 'XEPlugin', 'loading', ['hide']

	loading = {
		show: showLoading
		hide: hideLoading
	}

	xePlugin = {
		nav: nav
		run: run
		alert: xeAlert
		toast: toast
		loading: loading
	}
else
	push = (args)->
		window.location.href = "/webpack-dev-server/#{args[0]}.html"
	pop = ->
		window.history.back()
	popTo = (index)->
		window.history.go(-index-1)

	xeAlert = (message)->
		alert message
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
				console.log 'show loading', msg
			hide: ->
				console.log 'hide loading'
		}
		alert: xeAlert
	}

module.exports = xePlugin