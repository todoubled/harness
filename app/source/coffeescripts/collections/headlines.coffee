{Headline} = require '../models/headline.coffee'

class @Headlines extends Backbone.Collection
  url: '/headline'
  model: Headline
