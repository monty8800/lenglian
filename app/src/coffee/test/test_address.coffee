request = require './common'
should = require 'should'
config = require './config'

_addressId = "dae9e1dd2f4d40928a93b6cd228e7f6a"

describe '地址', ->

	# it '新增地址', (done) ->
	# 	request.post config.api.add_address, {
	# 		userId: '50819ab3c0954f828d0851da576cbc31'
	# 		province: '北京市'
	# 		city: '北京市'
	# 		area: '海淀区'
	# 		street: '泰鹏大厦'  + parseInt(Math.random()  * 10000)
	# 		latitude: '39.00'
	# 		longitude: '146.0089'   
	# 	}, (result) ->  
	# 		done()  
  

	it '我的地址列表', (done)->
		userId = '50819ab3c0954f828d0851da576cbc31'
		request.post config.api.ADDR_LIST, {
			userId: userId
		}, (result)->
			result.should.not.be.empty()
			_addressId = result[0].id
			done() 
  
	it '修改地址', (done)->
		request.post config.api.modify_address, {
			id: _addressId
			userId: '50819ab3c0954f828d0851da576cbc31'
			province: '北京市'
			city: '北京市'    
			area: '海淀区'
			street: '泰鹏大厦310'
			latitude: '39.00'
			longitude: '146.00'
		}, (result) ->
			done()

	# it '删除地址', (done)->
	# 	request.post config.api.del_address, {
	# 		id: _addressId
	# 		userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
	# 	}, (result) ->
	# 		done()  

