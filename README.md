# Gulp Devstack

## Features

- Javascript: Babelify + Browserify with uglify & sourcemaps => [latest ES preset](https://babeljs.io/docs/plugins/preset-latest/)
- Styles: LESS + autoprefix + [glob plugin](https://github.com/just-boris/less-plugin-glob)
	- Custom mixins
	- Pre-defined breakpoints
	- Structured LESS
	- [Modern CSS reset](https://benfrain.com/a-modern-css-reset-with-caveats/)
- Images: sprites w/ [gulp.spritesmith](https://github.com/twolfson/gulp.spritesmith)
- Livereload (use w/ [Google Chrome extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei))
- Mac OS X notifications on error and success

## Installation & run

### Installation

`npm install` & `gulp` or `npm install` & `gulp build`

### Run

1. For livereload: `gulp`
1. For one time build: `gulp build`

## Todo
- [ ] https://www.npmjs.com/package/gulp-if && http://stackoverflow.com/questions/27253597/is-it-possible-to-assign-a-variable-in-a-gulp-task-before-running-dependencies