request = require './common'
should = require 'should'
config = require './config'

describe '关注列表', ->
	it '关注列表', (done)->
		params = {
			userId: '43534efew',
			focustype: '1' # 1:司机 2：货主 3：仓库
		}
		request.post config.api.attention_list, params, (result)->
			done();