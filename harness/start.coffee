# ### Process Manager
#
# ###### Start multiple long running processes and kill all if one exits.
#
cp = require 'child_process'
fs = require 'fs'
processes = JSON.parse fs.readFileSync "#{require('path').normalize("#{__dirname}/..")}/harness/processes.json"
task = process.argv[2]

throw new Error("Array of processes not specified for #{task}") unless processes.hasOwnProperty task

#
# A task (passed in as a CLI argument) can define an array of commands to run with a corresponding key in `harness/processes.json`.
#
processes[task].forEach (proc) ->
  p = cp.spawn 'sh', ['-c', proc]
  p.stdout.setEncoding 'utf8'
  p.stderr.pipe process.stderr
  p.stdout.pipe process.stdout
  p.on 'exit', (code) ->
    process.kill 'SIGINT'
    process.exit code if code
