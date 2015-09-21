request = require './common'
should = require 'should'
config = require './config'

describe '库相关', ->
	it '查询我的仓库', (done)->
		params = {
			userId:'7714d0d83c7f47f4bcfac62b9a1bf101'
			status:'1'
			pageNow:1
			pageSize:10
		}
		request.post config.api.GET_WAREHOUSE, params, (result)->
			should.exists result
			done()


	it '删除我的仓库', (done)->
		params = {
			userId:'7714d0d83c7f47f4bcfac62b9a1bf101'
			warehouseId:'1221223456789'
		}
		request.post config.api.DELETE_WAREHOUSE, params, (result)->
			should.exists result
			done()

	it '修改我的仓库', (done)->
		params = {
			userId:'3456789'
			warehouseId:'4567890'
			remark:"刁兄的仓库。。。"		#备注
			phone:"1381231231232"		#联系人电话
			contacts:"刁兄"				#修改的联系人
		}
		request.post config.api.UPDATE_WAREHOUSE, params, (result)->
			should.exists result
			done()
			
	it '我的仓库详情', (done)->
		params = {
			userId:'7714d0d83c7f47f4bcfac62b9a1bf101'
			warehouseId:'9bea9e8f561d4922bc5709cc267ee0eb'
		}
		request.post config.api.WAREHOUSE_DETAIL, params, (result)->
			should.exists result
			done()

	it '增加仓库', (done)->
		params = {
			area:"1"						#区id
			city:"1"						#市id
			contacts:"张三"					#联系人
			isinvoice:"1"					#1:要发票 2：不要发票
			latitude:"111"					#纬度
			longitude:"112"					#经度
			name:"qw"						#仓库名称
			phone:"15535355533"				#联系电话
			province:"1"					#省id
			remark:"备注"					#备注
			street:"北京市"					#详细地址
			userId:"7714d0d83c7f47f4bcfac62b9a1bf101" 	#用户id
			file:''
			warehouseProperty:[
				#1：仓库类型；
					#仓库类型 1：驶入式 2：横梁式 3：平推式 4：自动立体货架式， 
				#2 仓库增值服务；
					# 增值服务 1：城配 2：仓配 3：金融 ，
				#3：仓库面积;
					# 仓库面积 1：常温 2：冷藏 3：冷冻 4：急冻 5：深冷，
				#4 价格
					# 价格 1：天/托 2：天/平
				{
				   	type:"1"		
				   	attribute:"1"	 
				   	value:""				#文本框需要输入的值
				   	typeName:"仓库类型"		#跟type对应中文
				   	attributeName:"驶入式"	#跟attribute对应中文
				}
				{
				   	type:"2"		
				   	attribute:"1"	 
				   	value:""				#文本框需要输入的值
				   	typeName:"仓库增值服务"	#跟type对应中文
				   	attributeName:"城配"		#跟attribute对应中文
				}
				{
				   	type:"2"		
				   	attribute:"2"	 
				   	value:""				#文本框需要输入的值
				   	typeName:"仓库增值服务"	#跟type对应中文
				   	attributeName:"仓配"		#跟attribute对应中文
				}
				{
				   	type:"3"		
				   	attribute:"1"	 
				   	value:"1000"			#文本框需要输入的值
				   	typeName:"仓库面积"		#跟type对应中文
				   	attributeName:"常温"		#跟attribute对应中文
				}
				{
				   	type:"3"		
				   	attribute:"3"	 
				   	value:"2000"			#文本框需要输入的值
				   	typeName:"仓库面积"		#跟type对应中文
				   	attributeName:"冷冻"		#跟attribute对应中文
				}
				{
				   	type:"4"		
				   	attribute:"2"	 
				   	value:""				#文本框需要输入的值
				   	typeName:"价格"			#跟type对应中文
				   	attributeName:"天/平"	#跟attribute对应中文
				}            
			]
		}
		request.post config.api.WAREHOUSE_ADD, params, (result)->
			should.exists result
			done()























