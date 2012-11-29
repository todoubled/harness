fs = require 'fs'
express = require 'express'
app = express.createServer()
path = require 'path'
root = path.normalize "#{__dirname}/.."
port = 8080

app.use express.static "#{root}/public"
app.use express.bodyParser()
app.use app.router

app.get '/example_json_endpoint', (req, res) ->
  data =
    "lat": 45.5236
    "lng": 122.6750
    "division": 'portland'
    "description": "Portland, OR, USA"
  res.send data


app.get '/', (req, res) ->
  html = fs.readFileSync "#{root}/public/index.html", 'utf8'
  res.send html


app.listen port
