request = require './common'
should = require 'should'
config = require './config'

describe '测试银行卡', ->
	it '根据卡号查询银行', (done)->
		cardNo = '6222001901100106378'

		request.post config.api.QUERY_BANK_BY_CARD, {
			cardNo: cardNo
		}, (result)->
			result.should.not.be.empty()
			result.bankName.should.not.be.empty()
			result.bankType.should.not.be.empty()
			done()