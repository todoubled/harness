# # `make build`
#
fs = require 'fs'
path = require 'path'
Stream = require 'stream'
{spawn} = require 'child_process'
cs = require 'coffee-script'
mkdirp = require 'mkdirp'
{uglify, parser} = require 'uglify-js'
root = path.normalize "#{__dirname}/.."

#
# ### `source/coffeescripts/dev-helper.coffee` to `public/dev-helper.js`
#
# Only used for development and not bundled for production.
#
compileHelperJs = spawn 'sh', ['-c', './script/env.sh coffee -c --output public source/coffeescripts/dev-helper.coffee']
compileHelperJs.stderr.pipe process.stderr
# ----


#
# ### `source/coffeescripts/integration.coffee` to `public/integration.js`
#
# Only used for development and not bundled for production.
#
compileHelperJs = spawn 'sh', ['-c', './script/env.sh coffee -c --output public source/coffeescripts/integration.coffee']
compileHelperJs.stderr.pipe process.stderr
# ----


# ### `source/coffeescripts/**/*.coffee` to `public/harness.js`
#
# Main application JS bundle.
#
jsOutput = "#{root}/#{process.env.JS_OUTPUT}"
compileBundleJs = spawn 'sh', ['-c', './script/env.sh browserify ./source/coffeescripts/app/index.coffee']
compileBundleJs.stdout.pipe fs.createWriteStream jsOutput
compileBundleJs.stderr.pipe process.stderr
compileBundleJs.stdout.on 'end', ->
  bundledJs = fs.readFileSync jsOutput, 'utf8'
  finalJs = if process.env.NODE_ENV is 'production'
              uglify.gen_code(uglify.ast_squeeze(uglify.ast_mangle(parser.parse(bundledJs.replace /\s*$/, ''))))
            else
              bundledJs.replace /[^\S\n]+\n/g, '\n'
  fs.writeFileSync jsOutput, finalJs
# ----



# ### `source/stylesheets/harness.styl` to `public/harness.css`
#
# Main application CSS bundle.
#
if process.env.NODE_ENV is 'production'
  compileBundleCss = spawn 'sh', ['-c', './script/env.sh stylus --compress < ./source/stylesheets/style.styl --include ./source/stylesheets/']
else if process.env.NODE_ENV is 'release'
  compileBundleCss = spawn 'sh', ['-c', './script/env.sh stylus < ./source/stylesheets/style.styl --include ./source/stylesheets/']
else
  compileBundleCss = spawn 'sh', ['-c', './script/env.sh stylus --line-numbers < ./source/stylesheets/style.styl --include ./source/stylesheets/']

compileBundleCss.stderr.pipe process.stderr
compileBundleCss.stdout.pipe fs.createWriteStream "#{root}/#{process.env.CSS_OUTPUT}"
# ----




# ### `src/stylesheets/integration.styl` to `public/integration.css`
#
# Only used for development and not bundled for production.
#
if process.env.NODE_ENV is 'production'
  compileHelperCss = spawn 'sh', ['-c', './script/env.sh stylus --compress < ./source/stylesheets/integration.styl --include ./source/stylesheets/']
else if process.env.NODE_ENV is 'release'
  compileHelperCss = spawn 'sh', ['-c', './script/env.sh stylus < ./source/stylesheets/integration.styl --include ./source/stylesheets/']
else
  compileHelperCss = spawn 'sh', ['-c', './script/env.sh stylus --line-numbers < ./source/stylesheets/integration.styl --include ./source/stylesheets/']

compileHelperCss.stderr.pipe process.stderr
compileHelperCss.stdout.pipe fs.createWriteStream "#{root}/public/integration.css"
# ----




# ### `source/templates/*.mustache` to `node_modules/tmplates`
#
# Templates rolled into `public/harness.js`.
#
# `source/templates/*.mustache` is piped into a `Templates` object that is exported by `node_modules/tmplates`.
#
# - Accessible via `Templates = require('tmplates');`
# - Keys are `source/templates/*.mustache` file names
# - Values are `source/templates/*.mustache` file contents
#
minifyBuffer = (buffer) -> buffer.toString().replace(/\n/g, "")
tmplates = "#{root}/node_modules/tmplates"
templates = "#{root}/source/templates"
templateKeys = []
bundleTemplateTally = 0
transformTemplateTally = 0
templateCount = fs.readdirSync(templates).length

bundleTemplates = new Stream()
bundleTemplates.setMaxListeners 0
bundleTemplates.writable = true
bundleTemplates.readable = true

# Close syntax after all buffers have been written.
bundleTemplates.end = ->
  if bundleTemplateTally < (templateCount - 1) then bundleTemplateTally++
  else bundleTemplates.emit 'data', new Buffer('};', 'utf8')

# Set key to file name and value to file contents.
bundleTemplates.write = (buffer) ->
  bundleTemplates.emit 'data', Buffer.concat [new Buffer("  '#{templateKeys.shift()}': '", 'utf8'), new Buffer(escape buffer, 'utf8'), new Buffer("'", 'utf8')]

transformTemplates = new Stream()
transformTemplates.setMaxListeners 0
transformTemplates.writable = true
transformTemplates.readable = true
transformTemplates.end = ->

# Comma delimit each key/value pair.
transformTemplates.write = (buffer) ->
  if transformTemplateTally < 1
    transformTemplates.emit 'data', new Buffer(minifyBuffer(buffer))
  else if transformTemplateTally <= (templateCount - 1)
    transformTemplates.emit 'data', new Buffer("#{minifyBuffer(buffer)},")
  else transformTemplates.emit 'data', new Buffer(minifyBuffer(buffer))
  transformTemplateTally++

mkdirp tmplates, (err) ->
  if err then throw err
  fs.writeFileSync "#{tmplates}/package.json", '{\n  "author": "make build",\n  "name": "tmplates",\n  "private": true,\n "description": "make build reads .mustache files into a requirable tmplates module",\n  "version": "0.0.1",\n  "repository": {\n    "url": ""\n  },\n "main": "./index",\n  "devDependencies": {},\n  "optionalDependencies": {},\n  "engines": {\n    "node": "*"\n  }\n}\n'
  bundleTemplates.pipe transformTemplates
  transformTemplates.pipe fs.createWriteStream "#{tmplates}/index.js"
  bundleTemplates.emit 'data', new Buffer('exports = this;this.Template = function(key){return unescape(Templates[key])};Templates = {', 'utf8')

  fs.readdirSync(templates).forEach (file) ->
    templateKeys.push file.split('.')[0]
    fs.createReadStream("#{templates}/#{file}").pipe bundleTemplates
