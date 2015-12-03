Immutable = require 'immutable'

Message = Immutable.Record {
	content: '' # 消息内容
	createTime: '' # 发送时间
	goodsPersonUserId: ''
	orderId: ''
	flag: ''

}

module.exports = Message