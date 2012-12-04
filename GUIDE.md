# Guide

###### A general tutorial on working with `harness`.

Write HTML, CSS and JavaScript with Mustache, Stylus and CoffeeScript.

---

`make install` to setup dependencies.

`make server` to start the development server and file watchers.

`make test` to start the auto-test runner.

### Compilation
`harness` supports CoffeeScript and Stylus right now.


### Testing
Testing is covered on both a unit and integration level.
Jasmine unit tests are run with [testem](https://github.com/airportyh/testem) and integration tests are run with [casper.js](http://casperjs.org).


### Dependency Management
Dependencies are managed with [`browserify`](https://github.com/substack/node-browserify). App code should be broken down into small [CommonJS](http://www.commonjs.org/) modules that are reusable and well tested.


### Deployment
Deployment is a bit different than the usual sense. `harness` can "deploy" to any directory on your local file system.
This makes it very easy to deploy your latest build to another repo on your filesystem, like a Rails app for example.


### API Mocks
`harness` makes it really easy to test your UI against specific data sets returned from an API.
You're free to hit actual remote endpoints if you want, but `harness` makes it very easy to save and reproduce edge-case API responses locally.
API mocks also make the integration tests fast, because API calls are local to the `harness` server.

---


#### Input
This setup allows you to work with the technologies you're used to and supports some common types of assets as input for the build system:

- `.mustache` templates
- `.styl` stylesheet modules
- `.coffee` and `.js` modules
- images

### Output
And it outputs optimized assets like you might expect:

- 1 `.js` file
- 1 `.css` file
- images

### Integration
Include the output assets in `public/` and create 2 new files for integration points with a server-side application:

__`.js` file for configuration and instantiation__
  - Allows configuration to be passed in from the server
  - Discourages auto-instantiation

__`.css` file for image and font rules and any necessary style overrides__
  - Allows image and font assets to be served up via the server caching strategies
  - Smooths out style differences post-integration





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
Define a `PROJECT_PREFIX` in `harness/env.sh` for deployment ease.
Built assets will use this prefix so you should also prefix font and image filenames with the same `PROJECT_PREFIX`.
