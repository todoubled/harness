# Guide

A general tutorial on working with `javascript-harness`.

`make install` to setup dependencies.
`make server` to start the development server and file watchers.
`make test` to start the auto-test runner.


## HTML
HTML should be stored in `.mustache` files kept in `src/templates`.
To access the `.mustache` templates, `Templates = require 'tmplates'` in a module
and `Templates 'mustache-file-name'` will return the contents of a given file name in `src/templates`.

#### Implementation
`.mustache` files are read from the filesystem and stored in an object with the file names as keys and file contents as values.
This object is written to a temporary `node_module` called `tmplates` that is created at build time.


## CSS
Stylus is preferred but CSS can also be imported.

#### Implementation
Standard `stylus` CLI setup.


## JavaScript
CoffeeScript is preferred but JavaScript can also be `require`'d. Modules should be written in the [CommonJS](http://www.commonjs.org/) format.

The general philosophy is to build apps by composing many small modules that represent one unit of functionality.
Each module exports an object that represents the publicly accessible API that is available via `require`.
Modules can add public methods to the API by exposing properties on top-level `this` in any given module file.

```
# ui-callbacks.coffee
{Search} = require '../wrappers/search.coffee'

@onEnterSearch = (event) ->
  new Search {event}
```

```
# event-handlers.coffee
{onEnterSearch} = require './ui-callbacks.coffee'

$('#search').on 'click', onEnterSearch
```

## Images and Fonts
TODO: Add ENV var to define prefix
For deployment ease, pick a common filename prefix for all assets.


#### Implementation
Standard `browserify` CLI setup.


## Tests
Code should have test coverage at the unit level and the integration/behavior level.

### Unit
Jasmine BDD syntax is used. Write method spies and test the unit-level plumbing of the code.

### Integration
Mocha Zombie tests are used to interact with the UI and test user flows.
