Immutable = require 'immutable'

BankCard = Immutable.Record {
	bankBelong:null			#所属银行   中国银行 建设银行
	cardCodeShort:null		#卡号  缩略格式 客户端不应显示完整卡号
	cardType:null			#卡种 	信用卡 储蓄卡
}
module.exports:BankCard