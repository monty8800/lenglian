gulp = require 'gulp'
plugins = require('gulp-load-plugins')()

gulp.task 'prepare', plugins.shell.task('cordova prepare')
gulp.task 'webpack', plugins.shell.task('webpack')
gulp.task 'clean', plugins.shell.task('rm -rf www/*')

gulp.task 'sass', ->
	plugins.rubySass('src/sass/*.scss').pipe(plugins.cssmin()).pipe(gulp.dest('build/css/'))


gulp.task 'watch', ->
	gulp.watch 'src/sass/**', ['sass']
	gulp.watch 'src/**', ['webpack']
	gulp.watch 'www/**', ['prepare']

gulp.task 'default', ['sass', 'watch']