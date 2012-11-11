fs = require 'fs'
{spawn} = require 'child_process'
path = require 'path'
mkdirp = require 'mkdirp'
root = path.normalize "#{__dirname}/.."

input = 'public/harness*'
output = process.env.OUTPUT || root

fileCopy = spawn 'sh', ['-c', "cp #{root}/#{input} #{output}"]
fileCopy.stderr.pipe process.stderr
fileCopy.stdout.on 'end', -> process.exit()
