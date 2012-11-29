fs = require 'fs'
express = require 'express'
livereload = require 'livereload'
root = require('path').normalize "#{__dirname}/.."
pub = "#{root}/app/public"
routesPath = "#{root}/app/routes.coffee"

app = express()
app.use app.router
app.use express.static pub
app.use express.bodyParser()


app.use require routesPath if fs.stat routesPath

if process.env.PORT is 8080
  refresher = livereload.createServer()
  refresher.watch pub

app.listen process.env.PORT or 8080
