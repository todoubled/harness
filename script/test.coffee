{spawn} = require 'child_process'
fs = require 'fs'
path = require 'path'
root = path.normalize "#{__dirname}/.."

# ### `test/unit/**/*.coffee` to `test/tests.js`
#
testsOutput = "#{root}/test/tests.js"
compileBundleTests = spawn 'sh', ['-c', './script/env.sh browserify ./test/unit/**/*.coffee']
compileBundleTests.stderr.pipe process.stderr
compileBundleTests.stdout.on 'end', ->
compileBundleTests.stdout.pipe fs.createWriteStream testsOutput
# ----
