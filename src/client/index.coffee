app = require "app"
BrowserWindow = require "browser-window"

class Main
  constructor: (@app) ->
    @mainWindow = null
    @initAppEvents()
  initAppEvents: () =>
    @app.on 'windows-all-closed', @onAllWindowsClosed

  onAllWindowsClosed: () =>
    if process.platform != 'darwin' # not sure if i like this?
      @app.quit()

  loadWindow: (path, options) =>
    @mainWindow = new BrowserWindow options
    @mainWindow.on "close", () ->
      @mainWindow = null
    @mainWindow.loadUrl "file://#{__dirname}/#{path}"
    @mainWindow.openDevTools()
    @mainWindow.show()
console.log "exec main"
main = new Main app
win = main.loadWindow "../web/index.html", { width: 800, height: 600 }
