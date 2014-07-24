crypto = require 'crypto'
path = require 'path'

CoffeeScript = require 'coffee-script'
CSON = require 'season'
fs = require 'fs-plus'
rmdir = require 'rimraf'

cacheDir = fs.absolute('./cache')

## This will clean out the cache directory every run
rmdir cacheDir, (error) ->

coffeeCacheDir = path.join(cacheDir, 'coffee')
CSON.setCacheDir(path.join(cacheDir, 'cson'))


getCachePath = (coffee) ->
  digest = crypto.createHash('sha1').update(coffee, 'utf8').digest('hex')
  path.join(coffeeCacheDir, "#{digest}.js")

getCachedJavaScript = (cachePath) ->
  if fs.isFileSync(cachePath)
    try
      fs.readFileSync(cachePath, 'utf8')

compileCoffeeScript = (coffee, filePath, cachePath) ->
  {js, v3SourceMap} = CoffeeScript.compile(coffee, filename: filePath, sourceMap: true)
  # Include source map in the web page environment.
  filePath = path.basename(filePath) #this path seems to be incorrect when it hits the atom dev tools
  if btoa? and JSON? and unescape? and encodeURIComponent?
    js = "#{js}\n//# sourceMappingURL=data:application/json;base64,#{btoa unescape encodeURIComponent v3SourceMap}\n//# sourceURL=#{filePath}"
  try
    fs.writeFileSync(cachePath, js)
  js

requireCoffeeScript = (module, filePath) ->
  coffee = fs.readFileSync(filePath, 'utf8')
  cachePath = getCachePath(coffee)
  js = getCachedJavaScript(cachePath) ? compileCoffeeScript(coffee, filePath, cachePath)
  module._compile(js, filePath)

module.exports =
  cacheDir: cacheDir
  register: ->
    Object.defineProperty(require.extensions, '.coffee', {
      writable: false
      value: requireCoffeeScript
    })
