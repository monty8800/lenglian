getRandom = (max)->
	Math.random() * max

v4 = ->
	id = ''

	for i in [0...36]
		if i is 14
			id += '4'
		else if i is 19
			id +=  '89ab'.charAt(getRandom 4)
		else if i is 8 or i is 13 or i is 18 or i is 23
			id += '-'
		else
			id += '0123456789abcdef'.charAt(getRandom 16)

	date = new Date()

	return 'xe' + id + date.getTime()

module.exports = {
	v4: v4
}