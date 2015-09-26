mobile = (input)->
	return /^1(3|4|5|6|7|8)\d{9}$/.test input

passwd = (input)->
	return /^[\da-zA-Z]{6}$/.test input

payPasswd = (input)->
	return /^[\da-zA-Z]{6,20}$/.test input

smsCode = (input)->
	return /^.{4,8}$/.test input

idCard = (input)->
	return /^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/.test input

carNum = (input)->
	return /^[\u4E00-\u9FA5][\da-zA-Z]{6}$/.test input

vinNum = (input)->
	return /^\S{1,20}$/.test input

name = (input)->
	return /^[\u4E00-\u9FA5]{2,30}$/.test input

company = (input)->
	return /^\S{1,50}$/.test input

businessLicenseNo = (input)->
	return /^[\da-zA-Z]{15}$/.test input

organizingCode = (input)->
	return /^[\dA-Z]{9}$/.test input

transLicenseNo = (input)->
	return /^\S{1,30}$/.test input

tel = (input)->
	return /^[\d\-]{6,11}$/.test input

street = (input)->
	return /^\S{1,20}$/.test input

remark = (input)->
	return /^\S{1,30}$/.test input

module.exports = {
	mobile: mobile #手机号
	passwd: passwd #登录注册密码
	smsCode: smsCode #短信验证码
	idCard: idCard #身份证号码
	vinNum: vinNum #车架号
	name: name #真实姓名
	company: company #公司名
	carNum: carNum #车牌号
	payPasswd: payPasswd #支付密码
	businessLicenseNo: businessLicenseNo #营业执照
	organizingCode: organizingCode #组织机构代码
	transLicenseNo: transLicenseNo #道路运输许可证
	tel: tel #固定电话
	street: street #详细地址
	remark: remark
}
