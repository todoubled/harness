# # `make itest`
#
cp = require 'child_process'
processes = ['make dev-server', 'casperjs test test/integration']

# ### Process Manager
#
# Run multiple long running processes and kill all if one exits.
#
processes.forEach (proc) ->
  p = cp.spawn 'sh', ['-c', proc]
  p.stdout.setEncoding 'utf8'
  p.stderr.pipe process.stderr
  p.stdout.pipe process.stdout
  p.on 'exit', (code) ->
    process.kill 'SIGINT'
    process.exit 1
