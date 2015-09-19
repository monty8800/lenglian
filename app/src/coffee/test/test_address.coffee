request = require './common'
should = require 'should'
config = require './config'

_addressId = ""

describe '地址', ->

	it '新增地址', (done) ->
		request.post config.api.add_address, {
			userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
			province: '110000'
			city: '110100'
			area: '110101'
			street: '泰鹏大厦111111'    
			licenseno: ''      
			createUser: '888888'   
		}, (result) ->  
			done()  
  

	# it '我的地址列表', (done)->
	# 	userId = '7714d0d83c7f47f4bcfac62b9a1bf101'
	# 	request.post config.api.ADDR_LIST, {
	# 		userId: userId
	# 	}, (result)->
	# 		result.should.not.be.empty()
	# 		_addressId = result[0].id
	# 		done() 
  
	# it '修改地址', (done)->
	# 	request.post config.api.modify_address, {
	# 		id: _addressId
	# 		userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
	# 		province: '110000'
	# 		city: '110100'    
	# 		area: '110101'
	# 		street: '泰鹏大厦1111111'
	# 	}, (result) ->
	# 		done()

	# it '删除地址', (done)->
	# 	request.post config.api.del_address, {
	# 		id: _addressId
	# 		userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
	# 	}, (result) ->
	# 		done()  

