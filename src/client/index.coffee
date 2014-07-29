app = require "app"
BrowserWindow = require "browser-window"

Menu = require "menu"
MenuItem = require('menu-item')

debug = require("debug")("client:index")

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
    return @mainWindow

  createMenu: () =>
    #@menu = new Menu()
    data = [{
      label: "File"
      submenu: [{
        label: 'Reload'
        click: =>
          debug "reload"
          @mainWindow.reloadIgnoringCache()
      }, {
        label: 'Toggle DevTools'
        click: =>
          debug "toggle"
          @mainWindow.toggleDevTools()
      },{
        label: 'Quit'
        click: ->
          debug "quit"
          app.quit()
      }]
    }]

    #for item in data
    #  @menu.append new MenuItem(item)
    @menu = Menu.buildFromTemplate data

    Menu.setApplicationMenu(@menu)


console.log "exec main"

main = new Main app
win = main.loadWindow "../web/index.html", {
  width: 800
  height: 600
  frame: true
}
main.createMenu()
