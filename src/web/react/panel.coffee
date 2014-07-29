React = require "react-atom-fork"
#util = require "util"
$ = require "jquery"
require "jquery-ui"
debug = require("debug")("react:panel")
{div} = React.DOM


module.exports = React.createClass {
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
    el = @getDOMNode()
    setPanelBody = () ->
      headerHeight = $(el).find(".panel-heading").outerHeight()
      panelHeight = $(el).height()
      actualHeight = (panelHeight - headerHeight) - 30#padding
      $( el )
        .find(".panel-body")
        .height(actualHeight)
      #  .width($(el).innerWidth())
    $( el )
      #.find(".panel-body")
      .resizable({
        handles: 'all'
        grid: [ 10, 10 ]
        stop: (e, ui) =>
          offset = $(el).offset()
          @setState {
            top: offset.top,
            left: offset.left,
            width: $(el).width(),
            height:  $(el).height()
          }
          setPanelBody()
      })
    $( el ).draggable({
      grid: [ 10, 10 ],
      snap: true
      stop: (e, ui) =>
        offset = $(el).offset()
        @setState {top: offset.top, left: offset.left}
        setPanelBody()
    })
    setPanelBody()

  componentWillUnmount: ->

  render: ->
#    debug util.inspect(@props)
    {width,height,top,left} = @props
    top = @state.top if @state.top?
    left = @state.left if @state.left?
    width = @state.width if @state.width?
    height = @state.height if @state.height?

    div {
      style: {
        position: "absolute"
        top: top
        left: left
        width: width
        height: height
      }
    }, div { className: "panel panel-default" },
      div { className: "panel-heading" }, @props.headerText
      div {
        className: "panel-body"
      }, @props.children
}
