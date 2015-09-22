# SEARCH_WAREHOUSE
request = require './common'
should = require 'should'
config = require './config'

describe '搜索相关', ->
	it '我要找库', (done)->
		params = {
			startNo:'0'		#'开始条数（坐标从0开始)'
			pageSize:'10'	#'每页显示多数条'
			provinceId:'99'	#'省id'
			cityId:'5'		#'市id'
			areaId:'9'		#'区ID'
			id:'234253654375'		#'仓库id'
			wareHouseType:[]		#'仓库类型（数组）'
			cuvinType:[]			#'库温类型（数组）'
			extensiveBegin:'100'		#'仓库面积开始'
			extensiveEnd:'200'			#'仓库面积结束'
		}
		request.post config.api.GET_WAREHOUSE, params, (result)->
			should.exists result
			done()

	
