Constants = require 'constants/constants'

getFullPath = (image, size)->
	return null if not image
	return image if /^(http:\/\/|file:\/\/|\/storage\/|\/var\/).*$/.test(image)
	# return image if /^(http:\/\/|file:\/\/)?\/.*\/.*$/.test(image) 
	result = Constants.imageServer
	paths = image.split('|')
	if paths.length > 1
		result = result + '/' +paths[1] + '/'
	#用正则表达式测试接口返回的图片是否带有尺寸
	if not /^.*\/\d+\/\d+\/.+$/.test paths[0]
		result += size.replace /^(\d+)x(\d+)$/, '/$1/$2/'
	result += paths[0]
	return result

	 
module.exports = {
	getFullPath: getFullPath
	avatar: require 'avatar'
	default: require 'default'
}