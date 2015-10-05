request = require './common'
should = require 'should'
config = require './config'

describe '货主订单详情', ->
	# it '货主订单详情', (done)->
	# 	params = {
	# 		userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
	# 		orderNo: '1' # 订单号
	# 	}
	# 	console.log config.api.goods_order_detail
	# 	request.post config.api.goods_order_detail, params, (result)->
	# 		# should.exists result
	# 		# result.myCarInfo should.be.Array()
	# 		# result.myCarInfo[0].driver.should.not.be.empty()
	# 		done();   

	it '货源详情', (done) ->
		params = {
			userId: '50819ab3c0954f828d0851da576cbc31',
			id:'665a4a2a311547e5a4be6defeb67cbd4' 
			}   
		request.post config.api.GET_GOODS_DETAIL, params, (result)->   
			should.exists result
			done()


			# {"code":"0000","data":{"certification":"1","goodScore":8,"imgurl":null,"mjGoodsResource":{"advance":null,"arrivalEtime":"2015-09-07 00:00:00","arrivalStime":"2015-09-02 00:00:00","coldStoreFlag":"1","contacts":"11","createTime":"2015-09-24 15:16:38","createUser":null,"cube":"22","delTime":null,"delUser":null,"fromArea":"379","fromAreaName":null,"fromCity":"33","fromCityName":null,"fromLat":null,"fromLng":null,"fromProvince":"2","fromProvinceName":null,"fromStreet":null,"goodsType":1,"id":"665a4a2a311547e5a4be6defeb67cbd4","imgurl":"c7c80dc41b554a63aeb3cad531599a20.jpg","installEtime":"2015-09-07 00:00:00","installStime":"2015-09-01 00:00:00","isDel":null,"isinvoice":"2","mask":null,"mjGoodsRoutes":[],"name":"开通区域","packType":"哈哈哈哈","payType":1,"phone":"13211111111","price":"11","priceType":"1","receiver":null,"receiverMobile":null,"remark":"gggggggggggg","resourceStatus":"0","status":0,"toArea":"2570","toAreaName":null,"toCity":"267","toCityName":null,"toLat":null,"toLng":null,"toProvince":"22","toProvinceName":null,"toStreet":"11","updateTime":null,"updateUser":null,"userId":"50819ab3c0954f828d0851da576cbc31","version":null,"weight":"22"},"name":"黄呼叫","wishlst":false},"msg":"操作成功"}

