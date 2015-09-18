request = require './common'
should = require 'should'
config = require './config'

describe '省市区列表', ->
	it '省市区列表', (done)->
		request.post config.api.location_list, {}, (result) ->
			should.exists result
			result[0].rl.should.not.be.empty()
			result[0].rl[0].rl.should.not.be.empty()
			done()
  