'use strict';

g = require 'gulp'
$ = require('gulp-load-plugins')({ lazy: false })

browserify = require 'browserify'
babelify = require 'babelify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'

# Paths
path =
	app: '.'
	dist: './dist'

g.task 'scripts', ->
	b = browserify "#{path.app}/js/main.js", {debug: true}
			.transform babelify, {presets: ["latest"]}

	return b.bundle()
		.on 'error', $.notify.onError "Scripts error: <%= error.message %>"
		.pipe source 'main.min.js'
    	.pipe buffer()
		.pipe $.sourcemaps.init {loadMaps: true}
		    .pipe $.uglify()
		    .on 'error', $.notify.onError "Scripts error: <%= error.message %>"
		.pipe $.sourcemaps.write '.'
		.pipe g.dest path.dist
		.pipe $.notify 'Scripts processed!'

g.task 'sprites', ->
	spriteData = g.src 'images/sprites/*.png'
		.pipe $.spritesmith
			imgName: '../images/sprites.png'
			cssName: 'sprites.less'
	spriteData.img
		#.pipe $.buffer()
		#.pipe $.imagemin()
		.pipe g.dest 'images/'

	spriteData.css
		.pipe g.dest 'less/'

	.pipe $.notify 'Sprites processed!'

g.task 'styles', ->
	g.src 'less/default.less'
		.pipe $.less
			plugins: [require 'less-plugin-glob']
		.on 'error', $.notify.onError "Styles error: <%= error.message %>"
		.pipe $.autoprefixer "> 1%"
		.pipe $.cssmin keepSpecialComments: 0
		.pipe g.dest path.dist
		.pipe $.notify 'Styles processed!'
		.pipe $.livereload()

g.task 'watch', ->
	$.livereload.listen()
	g.watch ['images/sprites/*.png'], ['sprites']
	g.watch ['js/*.js'], ['scripts']
	g.watch ['less/*.less', 'less/**/*.less'], ['styles']

g.task 'default', ['watch']
g.task 'build', ['sprites', 'scripts', 'styles']