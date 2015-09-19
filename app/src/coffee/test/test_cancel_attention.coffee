request = require './common'
should = require 'should'
config = require './config'

describe '取消关注', ->
	it '取消关注', (done)->
		request.post config.api.cancel_attention, {
			id: '7714d0d83c7f47f4bcfac62b9a1bf101'
			userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
		}, (data) ->
			done()             