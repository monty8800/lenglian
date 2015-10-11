request = require './common'
should = require 'should'
config = require './config'

describe '货相关的操作', ->
	# it '删除货源', (done)->
	# 	params = {
	# 		userId:'50819ab3c0954f828d0851da576cbc31',
	# 		id:'77a5d38d06fa4ba9b6dd06848466172a'
	# 		}
	# 	request.post config.api.DELETE_GOODS, params, (result)->   
	# 		should.exists result
	# 		done()

	it '货源详情', (done) ->
		params = {
			userId: '50819ab3c0954f828d0851da576cbc31',
			id:'336accc50b4e48aeab5a8f5fd31761f0' 
			}   
		request.post config.api.GET_GOODS_DETAIL, params, (result)->   
			should.exists result
			done()




