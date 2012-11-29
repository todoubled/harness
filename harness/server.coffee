express = require 'express'
livereload = require 'livereload'
root = require('path').normalize "#{__dirname}/.."
routes = require "#{root}/app/routes.coffee"
pub = "#{root}/app/public"

if process.env.PORT is 8080
  refresher = livereload.createServer()
  refresher.watch pub

app = express()
app.use express.static pub
app.use express.bodyParser()
app.use app.router
app.use routes
app.listen process.env.PORT or 8080
