# ## URL Configuration
# Run `make server` and add query string params to `localhost:8080` to test the app against different versions of dependencies and A/B variants.
#
jQueryMatch = /jquery=([\w\.]+)/.exec location.search
backboneMatch = /backbone=([\w\.]+)/.exec location.search
underscoreMatch = /underscore=([\w\.]+)/.exec location.search
mustacheMatch = /mustache=([\w\.]+)/.exec location.search
variantMatch = /variant=([\w\.]+)/.exec location.search


supportedVersions =
  jquery: ['1.6.4', '1.8.1']
  backbone: ['0.5.3', '0.9.2']
  underscore: ['1.3.3']
  mustache: ['0.5.0-dev']
  variant: ['a', 'b']


setVersion = (dep, version) ->
  if version and supportedVersions[dep].indexOf(version[1]) isnt -1
    version[1]
  else
    if dep is 'variant'
      supportedVersions[dep][0]
    else supportedVersions[dep][supportedVersions[dep].length - 1]


window.jQueryVersion = setVersion 'jquery', jQueryMatch
window.backboneVersion = setVersion 'backbone', backboneMatch
window.underscoreVersion = setVersion 'underscore', underscoreMatch
window.mustacheVersion = setVersion 'mustache', mustacheMatch

# Define `Array.prototype.indexOf` for browsers without it natively (IE)
if !Array::indexOf
  Array::indexOf = (obj, start) ->
    i = start or 0
    j = @length

    while i < j
      return i if @[i] is obj
      i++
    -1
