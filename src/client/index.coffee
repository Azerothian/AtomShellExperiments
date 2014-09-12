app = require "app"
BrowserWindow = require "browser-window"

Menu = require "menu"
MenuItem = require('menu-item')

debug = require("debug")("client:index")

createWindow = (path, options, initDev = false) ->
  win = new BrowserWindow options
  win.loadUrl "file://#{__dirname}/#{path}"
  if initDev
    win.openDevTools()
  win.show()
  return win

mainWindow = null

app.on 'ready', () ->
  require('crash-reporter').start()

  app.on 'windows-all-closed', () ->
    if process.platform != 'darwin' # not sure if i like this?
      app.quit()

  mainWindow = createWindow "../web/index.html", {
    width: 800
    height: 600
    frame: true
  }, false

  menu = Menu.buildFromTemplate [{
    label: "File"
    submenu: [{
      label: 'Reload'
      click: ->
        debug "reload"
        mainWindow.reloadIgnoringCache()
    }, {
      label: 'Toggle DevTools'
      click: ->
        debug "toggle"
        mainWindow.toggleDevTools()
    },{
      label: 'Quit'
      click: ->
        debug "quit"
        app.quit()
    }]
  }]

  Menu.setApplicationMenu menu

  mainWindow.on "close", () ->
    mainWindow = null
