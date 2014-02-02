# watch-glob

Watch files and directories with glob patterns

## Installation

    npm install watch-glob

## Usage

**watchGlob(patterns, [options], addedCallback, [removedCallback] ])**

* `patterns` - a glob pattern or array of glob patterns to watch
* `options` - the base folder in which to search for the patterns (equivalent to `options.cwd`) an options object to pass to `glob()`, plus the following:
  * `callbackArg` - how the file should be represented on the callback
    * `absolute` - absolute path
    * `relative` - path relative to `options.cwd´
    * `vinyl` - a [vinyl-fs](https://github.com/wearefractal/vinyl-fs) object (experimental)
    * `object`(default) - { base, path, relative }
  * `delay` - (default: `2000`) sometimes Gaze does not seem to correctly watch folders which have not been created yet. Therefore, a 2000ms delay is used 
* `updateCallback` - function to be called when a file is changed, created, or "created" through a rename
* `removeCallback` - function to be called after a file is is deleted or "deleted" through a rename


## Example

    var watchGlob = require('watch-glob'),
        coffee = require('coffee-files');

    watchGlob(['tmp/**/*', 'lib/**/*'], { callbackArg: 'relative' }, function(filePath) {
      // Perform livereload
    });

    watchGlob('coffee/**/*.coffee', { cwd: 'src' }, function(filepath) {
      coffee.file(filepath.path, 'build/' + filepath.relative);
    });



