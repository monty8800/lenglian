request = require './common'
should = require 'should'
config = require './config'

describe '新增车辆', ->
	it '新增车辆', (done) ->
		params = {
			bulky: '11111' # 可载泡货
			carno: '傻b22224' # 车牌号
			category: '1' # 车辆类别
			driver: '司机' + parseInt(Math.random() * 100) # 随车司机
			heavy: '1' # 可载重货
			latitude: '39' # 纬度
			longitude: '146' # 经度
			phone: '13100000000' # 联系电话 
			type: '1' # 车辆类型
			userId: '50819ab3c0954f828d0851da576cbc31'
			vehicle: '2' # 车辆长度
			#id: '' # carId 应该是编辑车辆的时候用的
		}
		files = [
			{
				filed: 'imgUrl'
				path: 'src/images/car-02.jpg'
				name: 'imgUrl.jpg'    
			}
			{
				filed: 'drivingImg'
				path: 'src/images/car-03.jpg'
				name: 'drivingImg.jpg'
			}
			{
				filed: 'transportImg'
				path: 'src/images/car-04.jpg'
				name: 'transportImg.jpg'
			}
		]
		request.postFile config.api.add_car, params, files, (data) ->
			console.log 'data--------', data

