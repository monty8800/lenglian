gulp = require 'gulp'
plugins = require('gulp-load-plugins')()

# apiServer = 'http://192.168.26.177:7080/llmj-app/'
# apiServer = 'http://192.168.29.210:8072/' #朱舟
# apiServer = 'http://192.168.29.203:8072/' #盘代军
# apiServer = 'http://192.168.27.160:8080/llmj-app/' #高

apiServer = 'http://m.lenglianmajia.com/'


#webpack
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
config = require './webpack.config.js'

gulp.task 'webpack:build', ['pre-build'], (cb)->
	myConfig = Object.create config
	myConfig.output.publicPath = './'
	myConfig.plugins = myConfig.plugins.concat(
		new webpack.DefinePlugin({
			'process.env': {
				'NODE_ENV': JSON.stringify 'production'
			}
		}),
		new webpack.optimize.DedupePlugin(),
		new webpack.optimize.UglifyJsPlugin {
			compress: {
				drop_console: true
			}
			outSourceMap: false
		}
	) 
	webpack myConfig, (err, stats)->
			plugins.util.PluginError 'webpack', err  if err
			plugins.util.log '[webpack]', stats.toString {colors: true}
			cb()


devConfig = Object.create config
devConfig.devtool = 'eval-cheap-module-source-map'
devConfig.debug = true
devConfig.output.publicPath = './'
devCompiler = webpack devConfig
gulp.task 'webpack:dev', ['pre-build'], (cb)->
	devCompiler.run (err, stats)->
		throw new plugins.util.PluginError 'webpack:dev', err if err
		plugins.util.log '[webpack:dev]', stats.toString {colors: true}
		cb()


gulp.task 'webpack-dev-server', ['pre-build'], (cb)->
	serverConfig = Object.create config
	for key in Object.keys(serverConfig.entry)
		serverConfig.entry[key].unshift 'webpack-dev-server/client?http://localhost:8080', 'webpack/hot/dev-server'
	serverConfig.debug = true
	serverConfig.devtool = 'eval-cheap-module-source-map'
	serverConfig.plugins = serverConfig.plugins.concat(
		new webpack.HotModuleReplacementPlugin()
		)
 
	new WebpackDevServer webpack(serverConfig), {
		# publicPath: serverConfig.output.publicPath
		contentBase: serverConfig.output.path
		hot: true
		historyApiFallback: true
		proxy: {
			'*shtml': apiServer #反向代理，解决跨域
		}
		stats: {
			colors: true
		}
	}
	.listen 8080, 'localhost', (err)->
			throw new plugins.util.PluginError 'webpack-dev-server', err if err
			plugins.util.log '[webpack-dev-server]', 'http://localhost:8080/webpack-dev-server/home.html'


gulp.task 'build-dev', ['webpack:dev'], ->
	gulp.watch ['src/coffee/**/*', '!src/coffee/test/*'], ['webpack:dev']


gulp.task 'prepare', ['webpack'], plugins.shell.task('cordova prepare')

gulp.task 'clean', plugins.shell.task('rm -rf www/* build/*')

gulp.task 'sass', ['static'], ->
	plugins.rubySass('src/sass/*.scss').pipe(gulp.dest('build/css/'))

gulp.task 'static', ['copy-util'], plugins.shell.task('cp -r src/fonts src/images build/')

gulp.task 'copy-util', plugins.shell.task('cp bower_components/xe-common/js/mobileUtil.js www/util.js')

gulp.task 'todo', plugins.shell.task('grep -r "TODO" src -n > TODO.md')

gulp.task 'lint', plugins.shell.task('bash validate.sh')

gulp.task 'pre-build', ['sass', 'todo', 'lint']

gulp.task 'build', ['webpack:build'], plugins.shell.task('cordova prepare')

gulp.task 'coffee', ->
	gulp.src('src/coffee/test/*.coffee').pipe(plugins.coffee()).pipe(gulp.dest('test/'))

gulp.task 'mocha', ['coffee'], ->
	gulp.src(['test/*.js', '!test/common.js', '!test/config.js']).pipe(plugins.mocha())

gulp.task 'test', ->
	# 自动单元测试
	gulp.watch('src/coffee/test/*.coffee').on 'change', (file)->
		gulp.src(file.path).pipe(plugins.coffee()).pipe(gulp.dest('test/'))

	gulp.watch(['test/*.js', '!test/common.js', '!test/config.js']).on 'change', (file)->
		gulp.src(file.path, {read: false}).pipe(plugins.mocha({timeout: 10000})).on 'error', (err)->
			console.error '测试未通过', err

gulp.task 'default', ['webpack-dev-server', 'test']
