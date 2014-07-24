class Web
  constructor: ->
    @message = "howdoyoudo?"

  fireAlerts: =>
    debugger
    Web.fireJsAlert @message

  @fireJsAlert: (msg) ->
    alert msg
module.exports =  Web
