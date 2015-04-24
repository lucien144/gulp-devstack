fs                = require 'fs'
gulp              = require 'gulp'
coffee            = require 'gulp-coffee'
coffeeify         = require 'gulp-coffeeify'
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
Notification      = require 'node-notifier'
livereload        = require 'gulp-livereload'
cached            = require 'gulp-cached'

gulp.task 'install', ->

  # Register Handlebars
  handlebarsLayouts.register handlebars

  # Disallow .htaccess redirection www.example.com -> example.com
  htaccess = fs.readFileSync "#{__dirname}/.htaccess"
  htaccess = "#{htaccess}".replace /(www.example.com → example.com)([\s\S]*?)(<\/IfModule>)/gmi, '$1\n# Deleted.'

  # Allow .htaccess redirection example.com -> www.example.com
  pieceReg = new RegExp /(# Option 2:)([\s\S]*?)(# (<IfModule mod_rewrite\.c>)\n)([\s\S]*?)(# (<\/IfModule>))/gmi
  allReg = new RegExp /([\s\S]*?)(# Option 2:)([\s\S]*?)(# (<IfModule mod_rewrite\.c>)\n)([\s\S]*?)(# (<\/IfModule>))([\s\S]*)/gmi
  rules = htaccess.replace allReg, "$6"
  rules = rules.replace /#/gmi, ''
  htaccess = htaccess.replace pieceReg, "$1$2$4\n#{rules}\n$7"

  fs.writeFileSync "#{__dirname}/.htaccess", htaccess

spriteTemplate = (params) ->
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

gulp.task 'coffee', ->
  gulp.src 'coffee/*.coffee'
    .pipe cached 'coffees'
    .pipe coffeeify
      options:
        debug: true
    .pipe gulp.dest 'js'

gulp.task 'scripts', ['coffee'], ->
  gulp.src ['js/vendor/*.js','js/plugins.js', 'js/default.js']
    .pipe cached 'scripts'
    .pipe concat 'all.min.js'
    .pipe uglify()
    .pipe gulp.dest 'js'
    .pipe notify 'Scripts processed!'
    .pipe livereload()

gulp.task 'sprites-bg', ->
  spriteData = gulp.src('images/sprites-bg/*.jpg').pipe spritesmith
    imgName: '../images/sprites-bg.jpg'
    cssName: 'sprites-bg.less'
    cssOpts: 
      functions: true
    cssTemplate: (params) -> 
      spriteTemplate params

  spriteData.img
    .pipe imagemin()
    .pipe gulp.dest 'images/'

  spriteData.css
    .pipe gulp.dest 'less/'

gulp.task 'sprites-stickers', ->
  spriteData = gulp.src('images/sprites-stickers/*.png').pipe spritesmith
    imgName: '../images/sprites-stickers.png'
    cssName: 'sprites-stickers.less'
    cssOpts: 
      functions: true
    cssTemplate: (params) -> 
      spriteTemplate params

  spriteData.img
    .pipe imagemin()
    .pipe gulp.dest 'images/'

  spriteData.css
    .pipe gulp.dest 'less/'

gulp.task 'sprites-scene', ->
  spriteData = gulp.src('images/sprites-scene/*.png').pipe spritesmith
    imgName: '../images/sprites-scene.png'
    cssName: 'sprites-scene.less'
    cssOpts: 
      functions: true
    cssTemplate: (params) -> 
      spriteTemplate params

  spriteData.img
    .pipe imagemin()
    .pipe gulp.dest 'images/'

  spriteData.css
    .pipe gulp.dest 'less/'

gulp.task 'sprites', ['sprites-bg', 'sprites-stickers', 'sprites-scene'], ->
  spriteData = gulp.src('images/sprites/*.png').pipe spritesmith
    imgName: '../images/sprites.png'
    cssName: 'sprites.less'
    cssOpts: 
      functions: true
    cssTemplate: (params) -> 
      spriteTemplate params

  spriteData.img
    .pipe imagemin()
    .pipe gulp.dest 'images/'

  spriteData.css
    .pipe gulp.dest 'less/'

  .pipe notify 'Sprites processed!'

gulp.task 'styles', ->
  gulp.src 'less/default.less'
    .pipe cached 'styling'
    .pipe less()
    .on 'error', notify.onError "Error: <%= error.message %>"
    .pipe prefix "> 1%"
    .pipe cssmin keepSpecialComments: 0
    .pipe gulp.dest 'css'
    .pipe notify 'Styles processed!'
    .pipe livereload()

gulp.task 'watch', ->
  livereload.listen()
  gulp.watch ['coffee/*.coffee'], ['scripts']
  gulp.watch ['images/sprites/*.png', 'images/sprites-bg/*.jpg', 'images/sprites-stickers/*.jpg'], ['sprites']
  gulp.watch ['less/*.less', 'less/**/*.less'], ['styles']

gulp.task 'default', ['watch']