'use strict';

g = require 'gulp'
s = require('browser-sync').create()
$ = require('gulp-load-plugins')({ lazy: false })
build = false

browserify = require 'browserify'
babelify = require 'babelify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
svgsprites = require 'gulp-svg-sprite'

# Paths
path =
	app: '.'
	dist: './dist'

g.task 'scripts', ->
	g.src "#{path.app}/js/*.js", {read: false}
		.on 'error', $.notify.onError "Scripts error: <%= error.message %>"
		.pipe $.tap (file) ->
			b = browserify file.path, {debug: true}
				.transform babelify, {presets: ["latest"]}
			file.contents = b.bundle()
			console.log "-> Bundling: #{file.path}"
		.pipe buffer()
		.pipe $.if build is true, $.sourcemaps.init {loadMaps: true}
		.pipe $.if build is true, $.uglify()
		.pipe $.sourcemaps.write '.'
		.pipe g.dest path.dist
		.pipe $.notify 'Scripts processed!'
		.pipe s.stream()

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

g.task 'svg', ->
	g.src 'images/sprites/*.svg'
		.pipe svgsprites
			mode:
				symbol:
					dest: '.'
					sprite: 'sprites.svg'
					example: !build
					render:
						less:
							template: './less/sprites-svg.less.tpl'
							dest: '../less/sprites-svg.less'
		.on 'error', $.notify.onError "Scripts error: <%= error.message %>"
		.pipe g.dest "images/"
		.pipe $.notify 'SVG sprites processed!'
		.pipe s.stream()

g.task 'styles', ->
	g.src 'less/default.less'
		.on 'error', $.notify.onError "Styles error: <%= error.message %>"
		.pipe $.less(plugins: [require 'less-plugin-glob'])
			.on 'error', $.notify.onError "Styles error: <%= error.message %>"
		.pipe $.autoprefixer ["> 1%", "last 2 versions"]
			.on 'error', $.notify.onError "Styles error: <%= error.message %>"
		.pipe $.if build is true, $.cssmin keepSpecialComments: 0
		.pipe g.dest path.dist
		.pipe $.notify 'Styles processed!'
		.pipe s.stream()

g.task 'html', ->
	g.src '*.pug'
		.on 'error', $.notify.onError "HTML error: <%= error.message %>"
		.pipe $.pug()
			.on 'error', $.notify.onError "HTML error: <%= error.message %>"
		.pipe g.dest path.dist
		.pipe $.notify 'HTML reloaded!'
		.pipe s.stream()

g.task 'watch', ->
	s.init
		open: false
		# proxy: 'domain.local'
		server:
			baseDir: path.dist

	g.watch ['*.html', '*.php', '*.pug'], g.parallel 'html', (done) ->
		done()
		s.reload()
	g.watch ['images/sprites/*.png'], g.parallel 'sprites'
	g.watch ['images/sprites/*.svg'], g.parallel 'svg'
	g.watch ['js/*.js'], g.parallel 'scripts'
	g.watch ['less/*.less', 'less/**/*.less'], g.parallel 'styles'

g.task 'set-build-env', (done) ->
  build = true
  done()

g.task 'default', g.parallel 'watch'
g.task 'build', g.series 'set-build-env', 'sprites', 'svg', 'scripts', 'styles', (done) ->
	$.notify 'Build done!'
	done()
