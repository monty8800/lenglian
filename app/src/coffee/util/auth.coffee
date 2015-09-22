UserStore = require 'stores/user/user'
Plugin = require 'util/plugin'

needLogin = (cb)->
	console.log UserStore.getUser()
	if not UserStore.getUser()?.id
		console.log 'need login!'
		Plugin.nav.push ['login']
	else
		console.log 'user id', UserStore.getUser()?.id
		cb()

module.exports = {
	needLogin: needLogin
}