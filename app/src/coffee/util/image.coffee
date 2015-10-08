Constants = require 'constants/constants'

getFullPath = (image, size)->
	return null if not image
	return image if /^(http|file).*$/.test image

	result = Constants.imageServer
	paths = image.split('|')
	if paths.length > 1
		result = result + '/' +paths[1] + '/'
	result += size.replace /^(\d+)x(\d+)$/, '/$1/$2/'
	result += paths[0]
	return result

	 
module.exports = {
	getFullPath: getFullPath
}