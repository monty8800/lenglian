request = require './common'
should = require 'should'
config = require './config'

title = '我的仓库详情'

describe title, ->

	it title, (done)->
		url = config.api.ware_house_detail

		request.post url, {
				userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
				warehouseId: '42951c18a8264a86912b348bd6019f8d'		
			}, (result)->
				done();   
