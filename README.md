# Gulp Devstack

My custom fronted devstack based on Gulp. Feel free to use or modify. Any PR welcomed.

## Features

- Javascript: Babelify + Browserify with uglify & sourcemaps => [latest ES preset](https://babeljs.io/docs/plugins/preset-latest/)
- Styles: LESS + autoprefix + [glob plugin](https://github.com/just-boris/less-plugin-glob)
	- Pre-defined breakpoints
	- Structured LESS
	- [HTML5 reset](https://github.com/murtaugh/HTML5-Reset)
	- Custom mixins
	- Autoprefix: > 1%, 2 latest versions
- Images: sprites w/ [gulp.spritesmith](https://github.com/twolfson/gulp.spritesmith)
- Livereload (use w/ [Google Chrome extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei))
- Mac OS X notifications on error and success

## Installation & run

### Installation

- `npm install`

### Run

1. For livereload: `gulp`
1. For one time build: `gulp build`

## Todo
- [ ] livereload ⃕ browser-sync ?
- [ ] gulp-iconify ⃕ gulp.spritesmith
- [x] [gulp-if](https://www.npmjs.com/package/gulp-if), [gulp variables](http://stackoverflow.com/questions/27253597/is-it-possible-to-assign-a-variable-in-a-gulp-task-before-running-dependencies)