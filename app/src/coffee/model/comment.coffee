Immutable = require 'immutable'

Comment = Immutable.Record {
	onsetId: null 			#评价人ID
	onsetRole: null 		#评价人角色
	onsetUsercode: null		#评价人手机号
	onsetName:null 			#评论人用户名称 
	onsetUrl:null 			#评论人头像地址 

	targetId: null			#被评价人ID
	targetRole: null 		#被评价人角色
	targetUsercode: null 	#被评价人手机号

	content:null 			#评价内容
	createTime:null 		#评价创建时间
	createUser:null 		#创建人
	updateTime: null			#评价更新时间
	updateUser: null		#评价更新人

	id:null 			
	orderNo: null 				#评价对应的订单号
	score: null         	#评价等级 1 2 3 4 5 星

	sumQuantity: null
	targetCertification: null
	version: null
}

module.exports = Comment