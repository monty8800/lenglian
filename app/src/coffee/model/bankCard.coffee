Immutable = require 'immutable'

BankCard = Immutable.Record {
	onwerName:null			#持卡人姓名
	bankName:null			#银行名称 "建设银行", 
	bankBranchName:null		#"南环路支行", 
	bankCode:null			#银行code
	bankMobile:null 		#预留手机号 "15321720999", 
	bankType:null		
	cardType:null			#卡种 	信用卡 储蓄卡
	cardName:null			#卡名  '龙卡通'
	cardNo:null 			# 卡号"6217000010062303072", 
	createTime:null		 
	createUser:null
	mainNo:null				#'622848xxxxxxxxxxxxx'
	delTime:null
	delUser:null 
	id:null				# 持卡人id userId "7201beba475b49fd8b872e2d1493844a", 
	isDel:null
	mobileCode:null
	updateTime:null 
	updateUser:null 
	userId:null 			#"7201beba475b49fd8b872e2d1493844a", 
	userIdNumber:null  	# 身份证 id  "12342342344234", 
	version:null
	zfNo:null 				# 银行在支付公司的编码  "105"
	mainNo:null 			#示例 622848**********
	checkNo:null 			# 校验位 '622848'
	picPath:null 			#//图片服务器路径
	bigPicName:null			#//大图片位置
	smallPicName:null 		#//小图片位置
}
module.exports = BankCard
