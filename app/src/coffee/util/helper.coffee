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
	switch type
		when '1' then '货到付款（线下）'
		when '2' then '回单付款（线下）'
		when '3' then '预付款（线上）'

priceType = (type) ->
	switch type
		when '1' then '一口价'
		when '2' then '竞价'

warehouseStatus = (status) ->
	switch status
		when '1' 
			'空闲中'
		when '2' 
			'已发布'
		when '3' 
		 	'使用中'
		
invoiceStatus = (status) ->
	switch status
		when '1'
			'可以开发票'
		when '2'
			'不可以开发票'

authStatus = (status)->
	switch status
		when 1 then '已认证'
		when 2 then '认证中'
		else '未认证'
		
	
	

module.exports = 
	carTypeMapper: carType # 车辆类型
	carCategoryMapper: carCategory # 车辆类别
	warehouseStatus: warehouseStatus #仓库状态
	invoiceStatus: invoiceStatus #支持不支持开发票
	authStatus: authStatus
	payTypeMapper: payType # 支付方式字典映射
	priceTypeMapper: priceType # 价格类型字典映射



