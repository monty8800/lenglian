request = require './common'
should = require 'should'
config = require './config'

describe '库相关', ->
	# it '查询我的仓库', (done)->
	# 	params = {
	# 		userId:'5b3d93775a22449284aad35443c09fb6'
	# 		status:'1'
	# 		pageNow:1
	# 		pageSize:10
	# 	}
	# 	request.post config.api.GET_WAREHOUSE, params, (result)->
	# 		should.exists result
	# 		done()


	# it '删除我的仓库', (done)->
	# 	params = {
	# 		userId:'5b3d93775a22449284aad35443c09fb6'
	# 		warehouseId:'4baafa99e31443478e2e7e8e263a7c00'
	# 	}
	# 	request.post config.api.DELETE_WAREHOUSE, params, (result)->
	# 		should.exists result
	# 		done()

	# it '修改我的仓库', (done)->
	# 	params = {
	# 		userId:'7201beba475b49fd8b872e2d1493844a'
	# 		warehouseId:'4567890'
	# 		remark:"刁兄的仓库。。。"		#备注
	# 		phone:"1381231231232"		#联系人电话
	# 		contacts:"刁兄"				#修改的联系人
	# 	}
	# 	request.post config.api.UPDATE_WAREHOUSE, params, (result)->
	# 		should.exists result
	# 		done()
			
	# it '我的仓库详情', (done)->
	# 	params = {
	# 		userId:'7714d0d83c7f47f4bcfac62b9a1bf101'
	# 		warehouseId:'42951c18a8264a86912b348bd6019f8d'
	# 	}
	# 	request.post config.api.WAREHOUSE_DETAIL, params, (result)->
	# 		should.exists result
	# 		done()

	# it '增加仓库', (done)->
	# 	params = {
	# 		area:"东城区"						#区id
	# 		city:"北京市"						#市id
	# 		contacts:"李某四"					#联系人
	# 		isinvoice:"1"					#1:要发票 2：不要发票
	# 		latitude:"111"					#纬度
	# 		longitude:"112"					#经度
	# 		name:"加班886"						#仓库名称
	# 		phone:"18088889999"				#联系电话
	# 		province:"北京市"					#省id
	# 		remark:"我在代码里下毒,你造么?"					#备注
	# 		street:"中南海"					#详细地址
	# 		userId:"5b3d93775a22449284aad35443c09fb6" 	#用户id
	# 		warehouseProperty:[
	# 			#1：仓库类型；
	# 				#仓库类型 1：驶入式 2：横梁式 3：平推式 4：自动立体货架式， 
	# 			#2 仓库增值服务；
	# 				# 增值服务 1：城配 2：仓配 3：金融 ，
	# 			#3：仓库面积;
	# 				# 仓库面积 1：常温 2：冷藏 3：冷冻 4：急冻 5：深冷，
	# 			#4 价格
	# 				# 价格 1：天/托 2：天/平
	# 			{
	# 			   	type:"1"		
	# 			   	attribute:"1"	 
	# 			   	value:""				#文本框需要输入的值
	# 			   	typeName:"仓库类型"		#跟type对应中文
	# 			   	attributeName:"驶入式"	#跟attribute对应中文
	# 			}
	# 			{
	# 			   	type:"2"		
	# 			   	attribute:"1"	 
	# 			   	value:""				#文本框需要输入的值
	# 			   	typeName:"仓库增值服务"	#跟type对应中文
	# 			   	attributeName:"城配"		#跟attribute对应中文
	# 			}
	# 			{
	# 			   	type:"2"		
	# 			   	attribute:"2"	 
	# 			   	value:""				#文本框需要输入的值
	# 			   	typeName:"仓库增值服务"	#跟type对应中文
	# 			   	attributeName:"仓配"		#跟attribute对应中文
	# 			}
	# 			{
	# 			   	type:"3"		
	# 			   	attribute:"1"	 
	# 			   	value:"1000"			#文本框需要输入的值
	# 			   	typeName:"仓库面积"		#跟type对应中文
	# 			   	attributeName:"常温"		#跟attribute对应中文
	# 			}
	# 			{
	# 			   	type:"3"		
	# 			   	attribute:"3"	 
	# 			   	value:"2000"			#文本框需要输入的值
	# 			   	typeName:"仓库面积"		#跟type对应中文
	# 			   	attributeName:"冷冻"		#跟attribute对应中文
	# 			}
	# 			{
	# 			   	type:"4"		
	# 			   	attribute:"2"	 
	# 			   	value:""				#文本框需要输入的值
	# 			   	typeName:"价格"			#跟type对应中文
	# 			   	attributeName:"天/平"	#跟attribute对应中文
	# 			}            
	# 		]
	# 	}
	# 	file = [{
	# 		filed: 'file'
	# 		path: 'src/images/car-02.jpg'
	# 		name: 'addWarehouse.jpg'    
	# 	}]
	# 	request.postFile config.api.WAREHOUSE_ADD, params, file, (result)->
	# 		should.exists result
	# 		done()


	it '货找库 下单', (done)->
		params = {
			userId:'5b3d93775a22449284aad35443c09fb6'
			warehouseId:'295dd8ab5f6442afae2542175efdba1e'
			orderGoodsId:'d881b05483ef4f59b4e36290136d7204'
		}
		request.post config.api.GOODS_BIND_WAREHOUSE_ORDER, params, (result)->
			should.exists result
			done()


			 




















