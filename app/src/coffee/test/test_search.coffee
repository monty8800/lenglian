# SEARCH_WAREHOUSE
request = require './common'
should = require 'should'
config = require './config'

describe '搜索相关', ->
	it '我要找库(搜索)', (done)->
		params = {
			startNo:'0'		#'开始条数（坐标从0开始)'
			pageSize:'10'	#'每页显示多数条'
			# wareHouseType:[]		#'仓库类型（数组）'
			# cuvinType:[]			#'库温类型（数组）'
			# extensiveBegin:'100'		#'仓库面积开始'
			# extensiveEnd:'200'			#'仓库面积结束'
		}
		request.post config.api.SEARCH_WAREHOUSE, params, (result)->
			should.exists result
			done()


	# it '仓库找货(搜索)', (done)->
	# 	params = {
	# 		startNo:'0'			#开始条数（坐标从0开始）
	# 		pageSize: '10'		#每页显示多数条
	# 		# fromProvinceId: '99'	#起始省id
	# 		# fromCityId: '32'		#起始市id
	# 		# fromAreaId:	'44'		#起始区ID
	# 		# toProvinceId: '88'		#目的省id
	# 		# toCityId: '55'			#目的区id
	# 		# toAreaId: '11'			#目的区id
	# 		# coldStoreFlag: '1'		#1不需要，2需要
	# 		# priceType: '1'			#价格类型 1：一口价 2：竞价
	# 		# isInvoice:'1'			# 1: 要发票 2：不要发票
	# 		# id:'4567890'			#货物id
	# 		# goodsType:[]			#货物类型（数组）
	# 		# beginTime: '2015-9-24'	#开始时间
	# 		# endTime: '2015-10-01'	#结束时间
	# 		# weightBegin:'1000kg'	#货物重量开始
	# 		# weightEnd: '200kg'		#货物重量结束
	# 	}
	# 	request.post config.api.WAREHOUSE_SEARCH_GOODS, params, (result)->
	# 		should.exists result
	# 		done()


	# it '查询我的货源', (done)->
	# 	params = {
	# 		userId:'50819ab3c0954f828d0851da576cbc31'
	# 		resourceStatus:''				#货源状态：1：求车（库）中:2：有人响应:3：已成交   选填不填查所有
	# 		pageNow:'1' 					#页码
	# 		pageSize:'10'					#每页条数
	# 	}
	# 	request.post config.api.GET_GOODS_LIST,params,(result)->
	# 		should.exists result
	# 		done()





