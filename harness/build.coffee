#
# # `make build`
#
# - Build templates from individual `.mustache` files into a requireable JavaScript object.
# - Bundle unit tests with browserify.
# - Compile integration script with CoffeeScript.
# - Compile helper script with CoffeeScript.
# - Bundle integration stylesheets with stylus.
# - Bundle main stylesheets with stylus.
# - Bundle main JavaScript with browserify.
# - Build in series, with templates first because they're a dependency for the assets.
#
fs = require 'fs'
browserify = require 'browserify'
{spawn} = require 'child_process'
mkdirp = require 'mkdirp'
async = require 'async'
root = require('path').normalize "#{__dirname}/.."
colors = require 'colors'
shell = (command) -> spawn 'sh', ['-c', "./harness/env.sh #{command}"]
stylusOptions = '--line-numbers'

tmplates = "#{root}/node_modules/tmplates"
templates = "#{root}/app/source/templates"

if process.env.NODE_ENV is 'release'
  stylusOptions = noLineNumbers = ''


bundleMainJs = (path) ->
  b = browserify entry: path
  fs.writeFileSync "#{root}/app/public/#{process.env.PROJECT_PREFIX}.js", b.bundle().replace(/[^\S\n]+\n/g, '\n')


handleStderr = (processes) ->
  processes.forEach (p) ->
    p.stderr.on 'data', (err) ->
      errorMsg = err.toString()
      console.log errorMsg.red.inverse unless errorMsg.match 'is now called'



#
# ### Templates
#
# (This is admittedly pretty ugly, but it's the best solution at the moment. Very open to other options without feature compromise.)
#
# `source/templates/*.mustache` is piped into a `Templates` object that is exported by `node_modules/tmplates`.
#
# - Accessible via `Templates = require('tmplates');`
# - Keys are `source/templates/*.mustache` file names
# - Values are `source/templates/*.mustache` file contents
#
buildTemplates = (next) ->
  lastPosition = fs.readdirSync(templates).length - 1

  mkdirp tmplates, (err) ->
    if err then throw err
    fs.writeFileSync "#{tmplates}/package.json", '{\n  "author": "make build",\n  "name": "tmplates",\n  "private": true,\n "description": "make build reads .mustache files into a requirable tmplates module",\n  "version": "0.0.1",\n  "repository": {\n    "url": ""\n  },\n "main": "./index",\n  "devDependencies": {},\n  "optionalDependencies": {},\n  "engines": {\n    "node": "*"\n  }\n}\n'
    fs.appendFileSync "#{tmplates}/index.js", 'exports = this;this.Template = function(key){return unescape(Templates[key])};Templates = {'

    fs.readdirSync(templates).forEach (file, index) ->
      fs.appendFileSync "#{tmplates}/index.js", "'#{file.split('.')[0]}': '#{escape fs.readFileSync("#{templates}/#{file}").toString()}'#{if index is lastPosition then '' else ','}"

    fs.appendFileSync "#{tmplates}/index.js", '};'
    next null
# ----



#
# ### Assets and Unit Tests
#
# - Unit tests compile to `harness-tests.js`
# - Helper and Integration files compile to `public/` with the same name as the source file.
# - Main JS and CSS compile to `public/PROJECT_PREFIX.{js, css}`.
#
buildAssets = (next) ->
  unitTests = shell 'browserify ./app/test/unit/**/*.coffee -o app/harness-tests.js'
  integrationJs = shell 'coffee -co app/public app/source/coffeescripts/integration.coffee'
  helperJs = shell 'coffee -co app/public app/source/coffeescripts/dev-helper.coffee'
  integrationStyles = shell "stylus #{stylusOptions} -I app/source/stylesheets/ -o app/public/ app/source/stylesheets/integration.styl"
  mainStyles = shell "stylus #{stylusOptions} -I app/source/stylesheets/ -o app/public/ app/source/stylesheets/#{process.env.PROJECT_PREFIX}.styl"
  handleStderr [unitTests, integrationJs, helperJs, integrationStyles, mainStyles]
  bundleMainJs 'app/source/coffeescripts/app/index.coffee'
  next null
# ----



#
# ## Build Series
#
# ####### Build templates first, then build assets that depend on those templates.
#
async.series [buildTemplates, buildAssets], (err) ->
  throw err if err
  console.log 'Build to app/public complete.'.green
# ----
