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

- `npm i`

### Commands

| Command | Definition |
|---------|------------|
| `gulp` / `gulp default` | Watching files, compile and livereload. |
| `gulp build` | Build assets for production |
| `scripts` | Build scripts. |
| `sprites` | Generate PNG sprites. |
| `svg` | Generate SVG sprites. |
| `styles` | Compile LESS. |
| `html` | Watch HTML. |
| `watch` | Watch. |
| `set-build-env` | Set ENV to production.  |


### Sprites

Sprites are created in pseudo element `:before`. Sprites are fully responsive, important is to keep the icon/image ratio when resizing.

```
<a class="ico-fb">Facebook</a> -> expecting to have ico-fb.{png|svg}, showing icon and text.
<a class="sprite ico-fb"><span>Facebook</span></a> -> expecting to have ico-fb.{png|svg}, showing only icon and hiding text.
<a class="sprite sprite--center ico-fb"><span>Facebook</span></a> -> expecting to have ico-fb.{png|svg}, showing only icon and hiding text, centered in all directions.
```

If you create files `sprite.svg` and `sprite-hover.svg`, the `:hover` is added automatically.

### Mixins / pre-defined classes

| Mixin / Class | Definition |
|---------------|------------|
| `.skir` | Scott Kellum Image Replacement |
| `.font-antialiasing()` | Alias for `-webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;` |
| `.top-left(top: 0, left: 0, z-index: '', position: absolute)` | |
| `.top-left-f(...)` | Alias for fixed position. |
| `.top-right(...)` | |
| `.bottom-left(...)` | |
| `.bottom-right(...)` | |
| `.size(@width: auto, [@height: auto])` | Example: .size(10px); .size(10px, 10px); |
| `.pseudo(@display: inline-block)` | Alias for `display: @display; content: "";` |
| `.bg(@image, @position: 0 0, @repeat: no-repeat, @color: transparent)` | |
| `.bgc(@color: #fff)` | |
| `.test(@c: red)` | |
| `.triangle-t(@width, @height, @color)` | Makes top triangle. ▲ |
| `.triangle-b(...)` | Makes bottom triangle. ▼ |

## Todo
- [x] livereload ⃕ browser-sync ?
- [ ] [less-plugin-npm-import](https://github.com/less/less-plugin-npm-import) ?
- [x] [gulp-if](https://www.npmjs.com/package/gulp-if), [gulp variables](http://stackoverflow.com/questions/27253597/is-it-possible-to-assign-a-variable-in-a-gulp-task-before-running-dependencies)
