put = (key, value)->
	if typeof(value) is 'string' and value.constructor is String
		localStorage.setItem key, value
	else
		localStorage.setItem key, JSON.stringify(value)

get = (key)->
	result = localStorage.getItem key
	try
		result = JSON.parse result
	catch e
		console.log 'not json, return string'
	finally
		return result

remove = (key)->
	localStorage.removeItem key

clear = ->
	localStorage.clear()

module.exports = 
	put: put
	get: get
	remove: remove
	clear: clear