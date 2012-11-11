# # `make server`
#
cp = require 'child_process'
processes = ['make dev-server', 'make watch-source', 'make watch-test', 'make reload']

# ### Process Manager
#
# Run multiple long running processes and kill all if one exits.
#
processes.forEach (proc) ->
  p = cp.spawn 'sh', ['-c', proc]
  p.stdout.setEncoding 'utf8'
  p.stderr.pipe process.stderr
  p.stdout.pipe process.stdout
  p.on 'exit', (code) -> process.exit(code) if code
