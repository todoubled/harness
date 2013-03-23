#!/usr/bin/env node
argv = require('optimist').argv
fs = require 'fs'

commands = ['dev', 'test', 'deploy']

showUsage = ->
  fs.createReadStream(__dirname + '/usage.txt')
    .pipe(process.stdout)
    .on 'close', ->
      process.exit 1


if argv._.length
  command = argv._[0]
  if commands.indexOf(command) isnt -1
    console.log command
  else
    showUsage()

else
  showUsage()
