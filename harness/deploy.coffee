#
# # `make deploy`
#
# - Accepts an OUTPUT environment variable to deploy the built assets to a specific path on the local filesystem.
# - Default output is the current working directory.
#
fs = require 'fs'
{spawn} = require 'child_process'
root = require('path').normalize "#{__dirname}/.."
input = "#{root}/app/public/#{process.env.PROJECT_PREFIX}*"
output = process.env.OUTPUT or root

throw new Error("You need to define a PROJECT_PREFIX environment variable to deploy.") unless input

fileCopy = spawn 'sh', ['-c', "cp #{input} #{output}"]
fileCopy.stderr.pipe process.stderr
fileCopy.stdout.on 'end', -> process.exit()
