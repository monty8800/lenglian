# request = require './common'
# should = require 'should'
# config = require './config'

# describe '新增车辆', ->
# 	it '新增车辆', (done) ->
# 		params = {
# 			{
# 				bulky: '11111' # 可载泡货
# 				carno: '22224' # 车牌号
# 				category: '1' # 车辆类别
# 				driver: '5555' # 随车司机
# 				heavy: '1' # 可载重货
# 				latitude: '1' # 纬度
# 				longitude: '1' # 经度
# 				phone: '55555' # 联系电话 
# 				type: '1' # 车辆类型
# 				userId: '222'
# 				vehicle: '2' # 车辆长度
# 				#id: '' # carId 应该是编辑车辆的时候用的
# 			}
# 			imgUrl: 'dddd' # 车辆图片
# 			drivingImg: 'aaaa' # 行驶证图片
# 			transportImg: 'ffff' # 道路运输许可证图片
# 		}	
# 		request.post config.api.add_car, params, (data) ->
# 			console.log 'data--------', data

