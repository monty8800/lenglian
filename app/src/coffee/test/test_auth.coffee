request = require './common'
should = require 'should'
config = require './config'

describe '测试认证', ->
	# it '个人认证',(done) ->
	# 	params = {
	# 		phone:"13100000010"		#手机号
	# 		type:"1"				#认证类型1:货主 2:车主 3:仓库
	# 		username:"王永🐔"		#真实姓名
	# 		userId:"729667936d0d411daaa946e4592978f0"	#用户id
	# 		cardno:"12342342344234"		#身份证号
	# 		#车主认证需要的字段
	# 		carno:"1243x"			#车牌号码
	# 		frameno:"sfdj222"			#车架号
	# 	}

	# 	files = [
	# 		{
	# 			filed: 'idcardImg'
	# 			path: 'src/images/car-02.jpg'
	# 			name: 'idcardImg.jpg'
	# 		}
	# 		{
	# 			filed: 'drivingImg'
	# 			path: 'src/images/car-03.jpg'
	# 			name: 'drivingImg.jpg'
	# 		}
	# 		{
	# 			filed: 'taxiLicenseImg'
	# 			path: 'src/images/car-04.jpg'
	# 			name: 'taxiLicenseImg.jpg'
	# 		}
	# 	]

	# 	request.postFile config.api.PERSONINFO_AUTH, params, files, (data)->
	# 		data.should.equal 1
	# 		done()

	it '企业认证', (done)->
		params = {
			userId: '837164bf1b544abda5ba379c6ad92e56'
			name: '怡红院'
			type: '1' #1货主， 2车主， 3仓库
			province: 19 #省id
			city: 228
			area: 1147
			street: '喂人民服雾'
			phone: '18513468467'
			licenseno: 'adffad11'
			certifies: 'lkajldf' #组织资格代码
			permits: 'sdfad' #运输许可代码
			principalName: '容馍馍'
		}

		files = [
			{
				filed: 'businessLicenseImg'
				path: 'src/images/car-02.jpg'
				name: 'businessLicenseImg.jpg'
			}
			{
				filed: 'transportImg'
				path: 'src/images/car-03.jpg'
				name: 'transportImg.jpg'
			}
			{
				filed: 'doorImg'
				path: 'src/images/car-04.jpg'
				name: 'doorImg.jpg'
			}
		]

		request.postFile config.api.COMPANY_AUTH, params, files, (data)->
			data.should.equal 1
			done()


