fs = require 'fs'
{spawn} = require 'child_process'
root = require('path').normalize "#{__dirname}/.."
input = "#{root}/app/public/#{process.env.PROJECT_PREFIX}*"
output = process.env.OUTPUT or root

throw new Error("You need to define a PROJECT_PREFIX environment variable to deploy.") unless input

fileCopy = spawn 'sh', ['-c', "cp #{input} #{output}"]
fileCopy.stderr.pipe process.stderr
fileCopy.stdout.on 'end', -> process.exit()
