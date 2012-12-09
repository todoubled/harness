fs = require 'fs'
express = require 'express'
root = require('path').normalize "#{__dirname}/.."
pub = "#{root}/app/public"
headline = JSON.parse fs.readFileSync "#{root}/app/fixtures/headline-api.json", 'utf8'
html = fs.readFileSync "#{pub}/index.html", 'utf8'

module.exports = routes = express()

# ---

routes.get '/headline', (req, res) ->
  res.send headline
