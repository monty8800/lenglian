mobile = (input)->
	return /^1(3|4|5|6|7|8)\d{9}$/.test input

passwd = (input)->
	return /^.{6,20}$/.test input

smsCode = (input)->
	return /^.{4,8}$/.test input

module.exports = {
	mobile: mobile
	passwd: passwd
	smsCode: smsCode
}