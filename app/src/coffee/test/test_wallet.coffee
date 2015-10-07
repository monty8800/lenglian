request = require './common'
should = require 'should'
config = require './config'

describe '钱包_相关', ->
	# it '我的收入和支出', (done)->
	# 	request.post config.api.GET_WALLET_IN_OUT, {
	# 		userId: '4671d0d8c37f47f4bcfa2323222bf102'
	# 		type: '1'		#1-收入 2-支出
	# 	}, (data) ->
	# 		should.exists data
	# 		done()     

	# it '查询银行列表',(done)->
	# 	request.post config.api.GET_BANK_LIST, {
	# 		userId:'7201beba475b49fd8b872e2d1493844a'							#用户id
	# 	}, (data)->
	# 		should.exists data
	# 		done() 


	# it '根据银行卡号查询银行',(done)->
	# 	request.post config.api.GET_BANK_CARD_INFO, {
	# 		userId:'4671d0d8c37f47f4bcfa2323222bf102'							#用户id
	# 		cardNo:'6228480097678508670'							#银行卡号
	# 	},(data)->
	# 		should.exists data
	# 		done()


	# it '验证预留手机号码',(done)->
	# 	request.post config.api.VERITY_PHONE_FOR_BANK, {
	# 		userId:'7201beba475b49fd8b872e2d1493844a'							#用户id
	# 		cardName:'YYQ'						#银行卡姓名
	# 		cardNo:'6217000010062303071'							#银行卡号
	# 		blankName:'建设银行'						#银行名称 如:中国银行
	# 		cardType:'借记卡'						#银行卡类型 如:储蓄卡	
	# 		bankMobile:'153216207721234'						#银行预留手机号
	# 		userIdNumber:'363241199005251325'					# 用户身份证号
	# 		bankCode:'5b89d8838bfc0b35d3'						#银行编码
	# 		zfNo:'105'							#银行在支付公司的编码
	# 		bankBranchName:'南环路支行'				#银行支行
	# 	},(data)->
	# 		should.exists data
	# 		done()

	# it '添加企业银行卡', (done)->
	# 	request.post config.api.ADD_BANK_CARD_COMMPANY, {
	# 		userId:''								#用户id
	# 		cardName:''								#银行卡姓名
	# 		cardNo:''							#银行卡号
	# 		blankName:''								#银行名称 如:中国银行
	# 		cardType:''							#银行卡类型 如:储蓄卡	
	# 		bankMobile:	''							#银行预留手机号
	# 		userIdNumber:''							# 用户身份证号
	# 		bankCode:''								#银行编码
	# 		zfNo:''						#银行在支付公司的编码
	# 		bankBranchName:''						#银行支行
	# 	}, (data) ->
	# 		should.exists data
	# 		done()     
	
	# it '添加个人银行卡及绑定(建行)', (done)->
	# 	request.post config.api.ADD_BANK_CARD_PRIVET, {
	# 		id:'7201beba475b49fd8b872e2d1493844a'						# 不知道是什么ID
	# 		userId:'7201beba475b49fd8b872e2d1493844a'								#用户id
	# 		cardName:'YYQ'								#银行卡姓名
	# 		cardNo:'6217000010062305678'							#银行卡号
	# 		blankName:'建设银行'								#银行名称 如:中国银行
	# 		cardType:'借记卡'							#银行卡类型 如:储蓄卡	
	# 		bankMobile:	'15321720999'							#银行预留手机号
	# 		userIdNumber:'363241199005251325'							# 用户身份证号
	# 		mobileCode:'5689'											#验证码短信
	# 		bankCode:'5b89d8838bfc0b35d3'								#银行编码
	# 		zfNo:'105'						#银行在支付公司的编码
	# 		bankBranchName:'南环路支行'						#银行支行

	# 	}, (data) ->
	# 		should.exists data
	# 		done() 

	# it '添加个人银行卡及绑定(农行)', (done)->
	# 	request.post config.api.ADD_BANK_CARD_PRIVET, {
	# 		id:'7201beba475b49fd8b872e2d1493844a'						# 不知道是什么ID
	# 		userId:'7201beba475b49fd8b872e2d1493844a'								#用户id
	# 		cardName:'金穗通宝卡(银联卡)'								#银行卡姓名
	# 		cardNo:'6228480097678508670'							#银行卡号
	# 		blankName:'瑞士银行'								#银行名称 如:中国银行
	# 		cardType:'借记卡'							#银行卡类型 如:储蓄卡	
	# 		bankMobile:	'15321720999'							#银行预留手机号
	# 		userIdNumber:'363241199005251325'							# 用户身份证号
	# 		mobileCode:'5689'											#验证码短信
	# 		bankCode:'078403e4d180a28621'								#银行编码
	# 		zfNo:'105'						#银行在支付公司的编码
	# 		bankBranchName:'南环路支行'						#银行支行

	# 	}, (data) ->
	# 		should.exists data
	# 		done()

	# it '解绑银行卡', (done)->
	# 	request.post config.api.REMOVE_BANK_CARD, {
	# 		id:'7201beba475b49fd8b872e2d1493844a'						# 不知道是什么ID
	# 		userId:'7201beba475b49fd8b872e2d1493844a'								#用户id
			
	# 	}, (data) ->
	# 		should.exists data
	# 		done()





