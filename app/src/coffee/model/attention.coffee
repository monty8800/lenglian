Immutable = require 'immutable'

Attention = Immutable.Record {
	companyName:'' # 认证是公司就是公司名 
	userName: '' # 认证是个人就是用户名
	imgurl: '' # 头像
	focusid: '' # 被关注人的Id
	id: ''
	wishlist: null
}

module.exports = Attention