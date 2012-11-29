{Template} = require 'tmplates'

class @App extends Backbone.View
  template: Template 'hello-world'

  present: ->
    location: 'World'

  render: ->
    html = Mustache.to_html @template, @present()
    $(document.body).append html
