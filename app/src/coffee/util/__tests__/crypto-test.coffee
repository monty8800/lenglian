describe '测试加密解密', ->
	it 'aes加密', ->
		plainText = 'hello ywen'
		passwd = '1234567890123456'
		crypto = require '../crypto.coffee'
		result = crypto.aesEncrypt passwd, plainText
		expect(crypto.aesDecrypt passwd, result).toEqual(plainText)

	it 'rsa加密', ->
		fs = require 'fs'
		pubKey = fs.readFileSync __dirname + '/rsa_public_key.pem'
		privateKey = fs.readFileSync __dirname + '/private_key.pem'
		crypto = require '../crypto.coffee'
		plainText = 'http://wo.yao.cl'
		result = crypto.rsaEncrypt pubKey, plainText
		expect(result).not.toBeNull()
		expect(crypto.rsaDecrypt privateKey, result).toEqual(plainText)