crypto = require 'crypto'
constants = require 'constants'

rsaEncrypt = (pubKey, text)->
	pubKeyObj = {
		'key': pubKey
		'padding': constants.RSA_PKCS1_OAEP_PADDING
	}

	encryptData = crypto.publicEncrypt pubKeyObj, new Buffer(text)
	encryptData.toString 'base64'

rsaDecrypt = (privateKey, text)->
	privateKeyObj = {
		'key': privateKey
		'padding': constants.RSA_PKCS1_OAEP_PADDING
	}

	decryptData = crypto.privateDecrypt privateKey, new Buffer(text, 'base64')
	decryptData.toString 'utf-8'


aesEncrypt = (key, text, iv)->
	iv = iv ? new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
	cryptoFactory 'aes-128-cbc', true, key, text, iv

aesDecrypt = (key, text, iv)->
	iv = iv ? new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
	cryptoFactory 'aes-128-cbc', false, key, text, iv

#勿用，crypto-browserify没有实现des
desEncrypt = (key, text, iv)->
	iv = iv ? new Array(1, 2, 3, 4, 5, 6, 7, 8)
	cryptoFactory 'des-cbc', true, key, text, iv

desDecrypt = (key, text, iv)->
	iv = iv ? new Array(1, 2, 3, 4, 5, 6, 7, 8)
	cryptoFactory 'des-cbc', false, key, text, iv

cryptoFactory = (algorithm, encrypt, key, text, iv)->
	cipher = null
	if encrypt is true
		if iv
			cipher = crypto.createCipheriv algorithm, new Buffer(key), new Buffer(iv)
		else
			cipher = crypto.createCipher algorithm, new Buffer(key)
	else
		if iv
			cipher = crypto.createDecipheriv algorithm, new Buffer(key), new Buffer(iv)
		else
			cipher = crypto.createDecipher algorithm, new Buffer(key)

	# cipher.setAutoPadding true
	inType = if encrypt is true then 'utf-8' else 'base64'
	outType = if encrypt is true then 'base64' else 'utf-8'
	result = [cipher.update text, inType]
	result.push cipher.final()
	Buffer.concat(result).toString(outType)

module.exports = 
	rsaEncrypt: rsaEncrypt
	rsaDecrypt: rsaDecrypt
	aesEncrypt: aesEncrypt
	aesDecrypt: aesDecrypt
	desEncrypt: desEncrypt
	desDecrypt: desDecrypt