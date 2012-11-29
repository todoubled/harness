livereload = require 'livereload'
path = require 'path'
root = path.normalize "#{__dirname}/.."

server = livereload.createServer()
server.watch "#{root}/public"
