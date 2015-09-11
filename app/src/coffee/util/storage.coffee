put = (key, value)->
	localStorage.setItem key, JSON.stringify(value)

get = (key)->
	localStorage.getItem key

remove = (key)->
	localStorage.removeItem key

clear = ->
	localStorage.clear()

module.exports = 
	put: put
	get: get
	remove: remove
	clear: clear