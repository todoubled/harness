#
# ## Server
#
# ###### Mock API endpoints and serve static assets in `app/public`.
#
# - Define custom routes with `routesPath` for API endpoints.
# - Easy to mock edge-case result sets and fast, offline integration tests.
#
fs = require 'fs'
express = require 'express'
livereload = require 'livereload'
root = require('path').normalize "#{__dirname}/.."
pub = "#{root}/app/public"
routesPath = "#{root}/app/routes.coffee"
port = process.env.PORT || 8080

app = express()
app.use app.router
app.use express.static pub
app.use express.bodyParser()

# Use any custom routes if they're defined.
app.use require routesPath if fs.stat routesPath

# Don't start `livereload` when the integration tests are running headlessly on `8081`.
livereload.createServer().watch pub if port is 8080

# Allow the integration test runner to run at a different port to avoid collision with `make server` on `8080`.
app.listen port
