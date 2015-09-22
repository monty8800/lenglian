request = require './common'
should = require 'should'
config = require './config'

describe '明确当前角色是 司机 时的测试', ->
	it '司机找货' ,(done) ->
		params = {
			startNo:'0'			#'开始条数（坐标从0开始）'
			pageSize:'10'	# '每页显示多数条'
			goodsType: '货物类型（数组）'
			fromProvinceId: '99'	#'起始省id'
			fromCityId: '5'		#'起始市id'
			fromAreaId: '9'		#'起始区ID'
			toProvinceId: '88'		#'目的省id'
			toCityId: '9'		#'目的市id'
			toAreaId: '2'		# 	'目的区id'
			priceType: 1 		#'价格类型 1：一口价 2：竞价'
			coldStoreFlag: 1	#'是否需要冷库1不需要，2需要，3目的地需要，4起始地需要'
			isInvoice: 1		#'1：要发票 2：不要发票'
			id: '233564756879'	#'货物id(附近搜索需要用到)'
		}
		request.post config.api.DRIVER_FIND_GOODS, params, (result)->
			should.exists result
			done()


	it '车源列表' ,(done) -> #司机 竞价/抢单 时获取自己车源列表
		params = {
			userId:'34567890'		#'用户ID'
			goodsResourceId:'f234234tt346453734' 		#'货源ID'	
		}
		request.post config.api.GET_CARS_FOR_BIND_ORDER ,params, (result) ->
			should.exists result
			done()


	it '司机找货抢单' ,(done) ->
		params = {
			userId:'34567890'		#'用户ID'
			carResourceId:'3456789tyui'			#车源ID
			goodsResourceId:'f234234tt346453734' 		#'货源ID'	
		}
		request.post config.api.DRIVER_BIND_ORDER ,params, (result) ->
			should.exists result
			done()

	it '司机找货竞价' ,(done) ->
		params = {
			userId:'324536476586'		#用户ID
			carResourceId:'13423545'		#车源ID
			goodsResourceId:'qrwt53654'		#货源ID
			price:'1000'				#竞价金额
		}
		request.post config.api.DRIVER_BID_FOR_GOODS ,params, (result) ->
			should.exists result
			done()











