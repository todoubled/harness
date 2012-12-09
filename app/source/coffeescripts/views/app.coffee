{Template} = require 'tmplates'
{Headlines} = require '../collections/headlines.coffee'

class @App extends Backbone.View
  template: Template 'hello-world'

  initialize: ->
    new Headlines().fetch
      success: (collection) =>
        @render collection.models[0]


  present: (model) ->
    headline: model.get 'headline'


  render: (model) ->
    html = Mustache.to_html @template, @present model
    $(document.body).append html
