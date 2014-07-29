React = require "react-atom-fork"
#util = require "util"
$ = require "jquery"
$$ = require "jquery-ui"
debug = require("debug")("debug")
{div} = React.DOM


debug "jqui", $$

Panel =  React.createClass {
  propTypes:
    children: React.PropTypes.component.isRequired
  getInitialState: ->
    {}
  getDefaultProps: ->
    {
      top: 0
      left: 0
      width: 256
      height: 256
    }
  componentDidMount: ->
    headerHeight = $(@getDOMNode()).find(".panel-heading").height()
    panelHeight = $(@getDOMNode()).height()
    $(@getDOMNode()).find(".panel-body").height(panelHeight - headerHeight)


    $( @getDOMNode() ).find(".panel-body").resizable({handles: 'all', grid: [ 10, 10 ]})
    $( @getDOMNode() ).draggable({ grid: [ 10, 10 ], snap: true })

  componentWillUnmount: ->

  render: ->
#    debug util.inspect(@props)
    {width,height,top,left} = @state
    top = @props.top if !@state.top?
    left = @props.left if !@state.left?
    width = @props.width if !@state.width?
    height = @props.height if !@state.height?
    div {
      style: {
        position: "absolute"
        top: top
        left: left
      }
    }, div { className: "panel panel-default" },
      div { className: "panel-heading" }, @props.headerText
      div {
        className: "panel-body",
        style: {
          width: width
          height: height
        }
      }, @props.children
}

Main = React.createClass {
  render: ->
    div {},
      Panel { headerText: "Panel 1", width: "256px", height: "256px" }, div {}
      Panel { headerText: "Panel 2", width: "256px", height: "256px" }, div {}

}


el = document.getElementById "react"
component = React.renderComponent Main(), el

onresizeend = ->
  component.forceUpdate()

resizeTimeOut = undefined
window.onresize = ->
  clearTimeout resizeTimeOut
  resizeTimeOut = setTimeout onresizeend, 100


###
if !@props.width?
  width = @props.parent.width if @props.parent?
  width = $(window).width() if !@props.parent?
else
  width = @props.width

if !@props.height?
  height = @props.parent.height if @props.parent?
  height = $(window).height() if !@props.parent?
else
  height = @props.height


###
