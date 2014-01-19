# watch-glob

Watch files and directories with glob patterns


## Usage

**watchGlob(patterns, options, addedCallback[, removedCallback ])**

`addedCallback` is called when a file is changed, created, or "created" through a rename
`removedCallback` is called when a file is deleted or "deleted" through a rename

    var watchGlob = require('watch-glob');
    function livereload(filePath) { /* perform livereload */ }
    watchGlob(['tmp/**/*'], {}, livereload);

The `cwd` option can be used when relative paths are needed

    var watchGlob = require('watch-glob');
    var coffeeFun = require('coffee-file-fun')
    watchGlob(['coffee/**/*.coffee'], { cwd: 'src' }, function(filepath) {
      coffeeFun.globToDir(filepath, { cwd: 'src' }, 'tmp/coffee')
    });



