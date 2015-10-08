carType = (status)->
	switch status
		when '1' then '普通卡车'
		when '2' then '冷藏车'
		when '3' then '平板'
		when '4' then '箱式'
		when '5' then '集装箱'
		when '6' then '高栏'
		else '未知'

carCategory = (status) ->
	switch status
		when '1' then '单车'
		when '2' then '前四后四'
		when '3' then '前四后六'
		when '4' then '前四后八'
		when '5' then '后八轮'
		when '6' then '五桥'
		when '7' then '六桥'
		when '8' then '半挂'
		else '未知'	

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
			'可以开发票'
		when 2
			'不可以开发票'

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
		when 0
			'全部'
		when 1
			'求车中'
		when 2
			'求库中'
		when 3
			'有人响应'
		when 4
			'已成交'
		when 5
			'待评价'


goodsType = (type)->
	switch parseInt(type)
		when 1 then '常温'
		when 2 then '冷藏'
		when 3 then '冷冻'
		when 4 then '急冻'
		when 5 then '深冷'
		else '请选择'

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

whoYouAre = (who)->
	if who?
		switch parseInt(who)
			when 1 then '(个人)'
			when 2 then '(企业)'
	else
		''
	

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
