mobile = (input)->
	return /^1(3|4|5|6|7|8)\d{9}$/.test input

passwd = (input)->
	return /^.{6,20}$/.test input

smsCode = (input)->
	return /^.{4,8}$/.test input

idCard = (input)->
	return /^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/.test input

carNum = (input)->
	return /^[\u4E00-\u9FA5][\da-zA-Z]{6}$/.test input

vinNum = (input)->
	return /^\S{17}$/.test input

name = (input)->
	return /^[\u4E00-\u9FA5]+$/.test input

company = (input)->
	return /^\S+$/.test input


module.exports = {
	mobile: mobile
	passwd: passwd
	smsCode: smsCode
	idCard: idCard
	vinNum: vinNum
	name: name
	company: company
	carNum: carNum
}