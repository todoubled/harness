#
# # `make build`
#
# This script builds assets for production and testing.
# It resolves dependencies and turns many small source files into a few larger files.
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
colors = require 'colors'
shell = (command) -> spawn 'sh', ['-c', "./harness/env.sh #{command}"]
stylusOptions = '--line-numbers'


# Directories
root = require('path').normalize "#{__dirname}/.."
appDir = process.env.APP_DIR || 'app'
projectPrefix = process.env.PROJECT_PREFIX
sourceDir = process.env.SOURCE_DIR || 'source'

# Paths
publicPath = "#{appDir}/public"
templateModulePath = "#{root}/node_modules/tmplates"
templatePath = "#{root}/#{appDir}/#{sourceDir}/templates"
coffeescriptPath = "#{appDir}/#{sourceDir}/coffeescripts"
stylesheetPath = "#{appDir}/#{sourceDir}/stylesheets"
unitTestPath = "#{appDir}/test/unit"

# Files
bundledJSFile = "#{publicPath}/#{projectPrefix}.js"
helperCoffeeFile = "#{coffeescriptPath}/helper.coffee"
harnessTestFile = "#{appDir}/harness-tests.js"
integrationCoffeeFile = "#{coffeescriptPath}/integration.coffee"
integrationStylesheetFile = "#{stylesheetPath}/integration.styl"
mainCoffeescriptFile = "#{coffeescriptPath}/#{projectPrefix}.coffee"
mainStylesheetFile = "#{stylesheetPath}/#{projectPrefix}.styl"
mainTemplateFile = "#{templateModulePath}/index.js"


if process.env.NODE_ENV is 'release'
  stylusOptions = noLineNumbers = ''


bundleMainJs = (path) ->
  b = browserify entry: path
  fs.writeFileSync bundledJSFile, b.bundle().replace(/[^\S\n]+\n/g, '\n')


handleStderr = (processes) ->
  processes.forEach (p) ->
    p.stderr.on 'data', (err) ->
      errorMsg = err.toString()
      console.log errorMsg.red.inverse unless errorMsg.match 'is now called'



#
# ### Templates
#
# `src/templates/*.mustache` is piped into a `Templates` object that is exported by `node_modules/tmplates`.
#
# - Accessible via `tmplates = require('tmplates');`
# - Keys are `src/templates/*.mustache` file names
# - Values are `src/templates/*.mustache` file contents
#
buildTemplates = (next) ->
  lastPosition = fs.readdirSync(templatePath).length - 1

  mkdirp templateModulePath, (err) ->
    if err then throw err
    fs.writeFileSync "#{templateModulePath}/package.json", '{\n  "author": "make build",\n  "name": "tmplates",\n  "private": true,\n "description": "make build reads .mustache files into a requirable tmplates module",\n  "version": "0.0.1",\n  "repository": {\n    "url": ""\n  },\n "main": "./index",\n  "devDependencies": {},\n  "optionalDependencies": {},\n  "engines": {\n    "node": "*"\n  }\n}\n'
    fs.appendFileSync mainTemplateFile, 'exports = this;this.Template = function(key){return unescape(Templates[key])};Templates = {'

    fs.readdirSync(templatePath).forEach (file, index) ->
      fs.appendFileSync mainTemplateFile, "'#{file.split('.')[0]}': '#{escape fs.readFileSync("#{templatePath}/#{file}").toString()}'#{if index is lastPosition then '' else ','}"

    fs.appendFileSync mainTemplateFile, '};'
    next null
# ----



#
# ### Build Assets and Unit Tests
#
# - Unit tests compile to `harness-tests.js`
# - Helper and Integration files compile to `public/` with the same name as the source file.
# - Main JS and CSS compile to `public/PROJECT_PREFIX.{js, css}`.
#
buildAssets = (next) ->
  unitTests = shell "browserify ./#{unitTestPath}/**/*.coffee -o #{harnessTestFile}"
  integrationJs = shell "coffee -co #{publicPath} #{integrationCoffeeFile}"
  helperJs = shell "coffee -co #{publicPath} #{helperCoffeeFile}"
  integrationStyles = shell "stylus #{stylusOptions} -I #{stylesheetPath}/ -o #{publicPath}/ #{integrationStylesheetFile}"
  mainStyles = shell "stylus #{stylusOptions} -I app/src/stylesheets/ -o #{publicPath}/ #{mainStylesheetFile}"
  handleStderr [unitTests, integrationJs, helperJs, integrationStyles, mainStyles]
  bundleMainJs mainCoffeescriptFile
  next null
# ----



#
# ## Build Series
#
# Build templatePath first, then build assets that depend on those templatePath.
#
async.series [buildTemplates, buildAssets], (err) ->
  throw err if err
  console.log "Build to #{publicPath} complete.".green
# ----
