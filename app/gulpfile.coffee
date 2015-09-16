gulp = require 'gulp'
plugins = require('gulp-load-plugins')()

gulp.task 'prepare', plugins.shell.task('cordova prepare')
gulp.task 'webpack', plugins.shell.task('webpack --display-error-details')
gulp.task 'clean', plugins.shell.task('rm -rf www/* build/*')

gulp.task 'sass', ->
	plugins.rubySass('src/sass/*.scss').pipe(plugins.cssmin()).pipe(gulp.dest('build/css/'))

gulp.task 'static', plugins.shell.task('cp -r src/fonts src/images build/')

gulp.task 'webpack-dev', plugins.shell.task('webpack-dev-server')

gulp.task 'serve', plugins.shell.task('ps -ef |grep "node app.js"|grep -Ev "grep"|awk \'{print $2}\'|xargs kill -9 && node app.js')

gulp.task 'todo', plugins.shell.task('grep -r "TODO" src -n > TODO.md')

gulp.task 'build', ['static', 'coffee', 'sass', 'webpack', 'todo'], plugins.shell.task('cp bower_components/xe-common/js/mobileUtil.js www/util.js')

gulp.task 'coffee', ->
	gulp.src('src/coffee/test/*.coffee').pipe(plugins.coffee()).pipe(gulp.dest('test/'))

gulp.task 'test', ['coffee'], ->
	gulp.src(['test/*.js', '!test/common.js', '!test/config.js']).pipe(plugins.mocha())

gulp.task 'watch', ->
	gulp.watch 'src/sass/**', ['sass']
	gulp.watch ['src/**', '!src/coffee/test/**'], ['webpack']
	gulp.watch 'www/**', ['prepare']
	# 自动单元测试
	gulp.watch('src/coffee/test/*.coffee').on 'change', (file)->
		gulp.src(file.path).pipe(plugins.coffee()).pipe(gulp.dest('test/'))

	gulp.watch(['test/*.js', '!test/common.js', '!test/config.js']).on 'change', (file)->
		gulp.src(file.path, {read: false}).pipe(plugins.mocha({timeout: 10000})).on 'error', (err)->
			console.error '测试未通过', err

gulp.task 'default', ['build', 'serve', 'watch']