carType = (status)->
	switch status
		when '1' then return '普通卡车'
		when '2' then return '冷藏车'
		when '3' then return '平板'
		when '4' then return '箱式'
		when '5' then return '集装箱'
		when '6' then return '高栏'
		else return '未知'

carCategory = (status) ->
	switch status
		when '1' then return '单车'
		when '2' then return '前四后四'
		when '3' then return '前四后六'
		when '4' then return '前四后八'
		when '5' then return '后八轮'
		when '6' then return '五桥'
		when '7' then return '六桥'
		when '8' then return '半挂'
		else return '未知'	

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

		
	
	

module.exports = 
	carTypeMapper: carType # 车辆类型
	carCategoryMapper: carCategory # 车辆类别
	warehouseStatus: warehouseStatus #仓库状态
	invoiceStatus: invoiceStatus #支持不支持开发票



