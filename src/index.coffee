_ = require('lodash')
Gaze = require('gaze').Gaze
path = require('path')
globule = require('globule')
Vinyl = require('vinyl')

watchGlob = (patterns, options, addedCallback, removedCallback) ->

  watcher = new Gaze([], { cwd: options?.cwd })

  setTimeout(( -> watcher.add(patterns)), options.delay)

  watcher.on 'all', (evt, absoluteFilepath) ->
    #console.log("watcher #{patterns}: event #{evt} on #{absoluteFilepath}")

    relativeFilepath = path.relative(options.cwd, absoluteFilepath)

    # Gaze seems to have a bug on Windows where an event is triggered on a subdirectory creation, although that directory does not match a pattern
    confirmMatch = globule.match(patterns, relativeFilepath)
    if confirmMatch.length == 0 then return

    valueForCallback =
      switch options?.callbackArg
        when 'absolute' then absoluteFilepath
        when 'relative' then relativeFilepath
        when 'vinyl' then new Vinyl({ cwd: options.base, path: absoluteFilepath })
        else { base: path.normalize(options.cwd), path: path.normalize(absoluteFilepath), relative: path.normalize(relativeFilepath) }  


    if evt in [ 'added', 'changed', 'renamed' ]
      addedCallback(valueForCallback)
    else if evt == 'deleted'
      removedCallback(valueForCallback)

  # Return object with destroy function
  {
    destroy: -> watcher.close.apply(watcher)
    watched: -> watcher.watched.apply(watcher)

  }




module.exports = (args...) ->
  # Handle arguments
  # (patterns[, options][, addedCallback][, removedCallback])
  
  patterns = if _.isArray(args[0]) then args[0] else [ args[0] ]
  callbacksIndex = null
  if _.isPlainObject(args[1])
    options = args[1]
    callbacksIndex = 2
  else if _.isString(args[1])
    options = { cwd: args[1] }
    callbacksIndex = 2  
  else
    options = {}
    callbacksIndex = 1


  options.cwd = options.cwd || process.cwd()
  
  addedCallback = args[callbacksIndex] || (->)
  removedCallback = args[callbacksIndex + 1] || (->)

  options.delay = if options.delay? then options.delay else 2000

  watchGlob(patterns, options, addedCallback, removedCallback)


