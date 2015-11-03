carType = (status)->
	if status is '' or undefined
		return ''
	switch parseInt(status)
		when 1 then '普通卡车'
		when 2 then '冷藏车'
		when 3 then '平板'
		when 4 then '箱式'
		when 5 then '集装箱'
		when 6 then '高栏'
		else ''

carCategory = (status) ->
	if status is '' or undefined
		return ''
	switch parseInt(status)
		when 1 then '单车'
		when 2 then '前四后四'
		when 3 then '前四后六'
		when 4 then '前四后八'
		when 5 then '后八轮'
		when 6 then '五桥'
		when 7 then '六桥'
		when 8 then '半挂'	
		else ''	

payType = (type) ->
	if type?
		switch parseInt(type)
			when 1 then '货到付款（线下）'
			when 2 then '回单付款（线下）'
			when 3 then '预付款（线上）'
	else
		''

priceType = (type) ->
	switch parseInt(type)
		when 1 then '一口价'
		when 2 then '竞价'
		
invoiceStatus = (status) ->
	switch parseInt(status)
		when 1
			'开发票'
		when 2
			'不开发票'

isInvoince = (status) ->
	switch parseInt(status)
		when 1
			'需要发票'
		when 2
			'不需要发票'
		else
			''

authStatus = (status)->
	switch parseInt(status)
		when 1 then '已认证'
		when 2 then '认证中'
		else '未认证'

carStatus = (status)->
	switch parseInt(status)
		when 1 then '空闲中'
		when 2 then '求货中'
		when 3 then '运输中'
warehouseStatus = (status) ->
	switch parseInt(status)
		when 1
			'空闲中'
		when 2 
			'已发布'
		when 3 
		 	'使用中'

goodsStatus = (status)->
	switch parseInt(status)
		when 1
			'求车(库)中'
		when 2
			'有人响应'
		when 3
			'已成交'
		else
			''


goodsType = (type)->
	switch parseInt(type)
		when 1 then '常温'
		when 2 then '冷藏'
		when 3 then '冷冻'
		when 4 then '急冻'
		when 5 then '深冷'
		else ''

warehouseType = (type)->
	switch parseInt(type)
		when 1 then '驶入式'
		when 2 then '横梁式'
		when 3 then '平推式'
		when 4 then '自动立体货架式'

#TODO:			
packType = (type) ->
	switch parseInt(type)
		when 1 then '硬纸壳'		

subStr = (start,length,str)->
	if str?
		if str.length > length
			str.substring start,length
		else
			str
	else
		''

hideName = (name)->
	name[0] + '**'

maxLength = (input, max)->
	input[0..max] + '...'

whoYouAre = (who)->
	if who?
		switch parseInt(who)
			when 1 then '(个人)'
			when 2 then '(企业)'
			else '(未认证)'
	else
		''
		
carVehicle = (status) ->
	if status?
		switch parseInt(status)
			when 1 then "3.8米以下"
			when 2 then "3.8米"
			when 3 then "4.2米"
			when 4 then "4.8米"
			when 5 then "5.8米"
			when 6 then "6.2米"
			when 7 then "6.8米"
			when 8 then "7.4米"
			when 9 then "7.8米"
			when 10 then "8.6米"
			when 11 then "9.6米"
			when 12 then "13~15米"
			when 13 then "15米以上"

goodsWeight = (index) ->
	if index?
		switch parseInt(index)
			when 1 then '2吨以下'
			when 2 then '2吨'
			when 3 then '3吨'
			when 4 then '4吨'
			when 5 then '5吨'
			when 6 then '6吨'
			when 7 then '8吨'
			when 8 then '10吨'
			when 9 then '12吨'
			when 10 then '15吨'
			when 11 then '18吨'
			when 12 then '20吨'
			when 13 then '25吨'
			when 14 then '28吨'
			when 15 then '30吨'
			when 16 then '30~40吨'
			when 17 then '40吨以上'
	else
		''

recordStatus = (_status, state) ->
	if parseInt(_status) is 1
		#充值
		if parseInt(state) is 1
			return '充值成功'
		else if parseInt(state) is 2
			return '充值中'
		else if parseInt(state) is 3
			return '充值失败'
	else if parseInt(_status) is 2
		# 提现
		if parseInt(state) is 1
			return '提现成功'
		else if parseInt(state) is 2
			return '提现中'
		else if parseInt(state) is 3
			return '提现失败'

hasSrting = (string)->
	Letters = "1234567890."
	for st in string
		if (Letters.indexOf st) is -1
			return true
	return false

isPriceFormat = (value,maxLength) ->
	if hasSrting value
		return false
	if value is '.'
		return false
	if value.length > 1
		if (value.substr 0,1) is '0' and  (value.substr 1,1) isnt '.'
			return false
	if (value.split '.').length > 2
		return false
	if (value.indexOf '.') isnt -1
		if (value.indexOf '.') + 3 < value.length
			return false
	else
		if value.length > maxLength
			if (value.substr maxLength,1) isnt '.'
				return false
	return true

priceFormatOnblur = (value)->
	if value in ['0','0.','0.0','0.00']
		return ''
	else if (value.substr (value.length-1),1) is '.'
		value = value.substr 0,value.length-1     #() + '00'
	else 
		value = value

	# else if (value.substr (value.length-2),1) is '.'
	# 	value = value + '0'

module.exports = 
	carTypeMapper: carType 				# 车辆类型
	carCategoryMapper: carCategory 		# 车辆类别
	warehouseStatus: warehouseStatus 	#仓库状态
	navStatus: carStatus				#车辆状态
	goodsStatus:goodsStatus				#货源状态
	invoiceStatus: invoiceStatus 		#支持不支持开发票
	authStatus: authStatus				#认证状态
	payTypeMapper: payType 				# 支付方式字典映射
	priceTypeMapper: priceType 			# 价格类型字典映射
	goodsType: goodsType 				#货物类型
	warehouseType:warehouseType 		#仓库类型
	packType:packType 					#货物打包类型
	subStr:subStr
	hideName: hideName
	isInvoinceMap: isInvoince
	whoYouAreMapper: whoYouAre
	carVehicle: carVehicle
	goodsWeight: goodsWeight
	maxLength: maxLength
	recordStatus: recordStatus
	isPriceFormat:isPriceFormat			#是否是正确的价格格式
	priceFormatOnblur : priceFormatOnblur	#价格编辑结束格式化价格