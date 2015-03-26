fs                = require 'fs'
gulp              = require 'gulp'
coffee            = require 'gulp-coffee'
uglify            = require 'gulp-uglify'
concat            = require 'gulp-concat'
less              = require 'gulp-less'
prefix            = require 'gulp-autoprefixer'
cssmin            = require 'gulp-cssmin'
imagemin          = require 'gulp-imagemin'
spritesmith       = require 'gulp.spritesmith'
handlebars        = require 'handlebars'
handlebarsLayouts = require 'handlebars-layouts'
notify            = require 'gulp-notify'

handlebarsLayouts.register handlebars

gulp.task 'coffee', ->
  gulp.src ['coffee/*.coffee']
    .pipe coffee bare: true
    .pipe gulp.dest 'js'
    .pipe notify 'Coffee processed!'

gulp.task 'scripts', ['coffee'], ->
  gulp.src ['js/vendor/*.js','js/plugins.js', 'js/default.js']
    .pipe concat 'all.min.js'
    .pipe uglify()
    .pipe gulp.dest 'js'
    .pipe notify 'Scripts processed!'

gulp.task 'sprites', ->
  spriteData = gulp.src('images/sprites/*.png').pipe spritesmith
    imgName: '../images/sprites.png'
    cssName: 'sprites.less'
    cssOpts: 
    	functions: true
    cssTemplate: (params) -> 

      handlebars.registerHelper 'makepseudo', (options) ->
      	options.fn(this).replace /-active|-focus|-hover|-visited|-checked|-disabled/gi, (matched) ->
          pseudoObj =
            "-active"  : ":active"
            "-focus"   : ":focus"
            "-hover"   : ":hover"
            "-visited" : ":visited"
            "-checked" : ":checked"
            "-disabled": ":disabled"
          pseudoObj[matched]

      handlebars.registerHelper 'removeHighdensity', (options) ->
      	options.fn(this).replace /@2x/gi, ''

      handlebars.registerHelper 'clean', (options) ->
      	options.fn(this).replace /[^a-z0-9]/ig, '-'

      params.sprites.forEach (sprite) ->
      	if new RegExp(/-active|-focus|-hover|-visited|-checked|-disabled/gi).test sprite.name
      	  sprite.pseudo = true
      	else
      	  sprite.pseudo = false

      	if new RegExp(/@2x/gi).test sprite.name
      	  sprite.highdensity = true
      	else
      	  sprite.highdensity = false

      source = fs.readFileSync "#{__dirname}/less/sprites.tpl.handlebars", 'utf8'
      template = handlebars.compile source
      template params

  spriteData.img
    .pipe imagemin()
    .pipe gulp.dest 'images/'

  spriteData.css
    .pipe gulp.dest 'less/'

  .pipe notify 'Sprites processed!'

gulp.task 'styles', ['sprites'], ->
  gulp.src 'less/default.less'
    .pipe less()
    .pipe prefix "> 1%"
    .pipe cssmin keepSpecialComments: 0
    .pipe gulp.dest 'css'
    .pipe notify 'Styles processed!'

gulp.task 'watch', ->
  gulp.watch ['coffee/*.coffee', 'js/**/*.js', '!js/all.min.js'], ['scripts']
  gulp.watch ['less/*.less', 'less/**/*.less'], ['styles']
  gulp.watch ['images/sprites/*.png'], ['sprites']

gulp.task 'default', ['scripts', 'styles', 'watch']
