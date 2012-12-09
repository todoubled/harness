# Guide

###### A general tutorial for working with `harness`.

Ship HTML, CSS and JavaScript by writing small Mustache, Stylus and CoffeeScript modules with unit and integration test coverage.

---


First, run `make install` to setup dependencies.
This will install all necessary node packages and tools.


`harness` expects a certain directory structure, some of which is configurable via environment variables.
Feel free to hack `harness/build.coffee` if you're not happy with the assumed directory structure:

```
 project-repository
 |- harness
   |- build.coffee
 |- app
   |- src
     |- coffeescripts
       |- views
       |- models
       |- index.coffee
       |- helper.coffee
       |- integration.coffee
     |- stylesheets
       |- hello-world.styl
       |- headline.styl
     |- templates
       |- layout.mustache
       |- headline.mustache
     |- vendor
       |- state-machine.js
   |- test
     |- unit
       |- main-app-view.coffee
       |- model.coffee
     |- integration
       |- pageload-behavior.coffee
   |- fixtures
     |- headline-api-response.json
   |- public
     |- index.html
     |- image.png
```

You can customize the names of the `app` and `src` directories by setting `APP_DIR` and `SOURCE_DIR` in `harness/env.sh`.

Assuming you've got the directory structure explained above, `make server` will start the development server and file watchers.

In a separate shell, run `make test` to start the auto-test runner.
Tests in `app/test/unit` will run every time a file in `app/test/unit` or `app/source` changes.

Periodically, run `make itest` to run the headless integration tests and ensure your UI is behaving as expected.

---


## HTML
HTML should be stored in `.mustache` files kept in `app/source/templates`.
To use the templates in a CoffeeScript module, require `tmplates` to use the `Template` getter object to return the contents of a file in `app/source/templates`.
```
Template = require 'tmplates'

# Log the contents of `app/source/templates/hello-world.mustache`.
console.log Template 'hello-world'
```


## CSS
Stylus is preferred but CSS can also be imported.
There are plans to support any preprocessing step in the future if you want to use Sass or Less.


## JavaScript
CoffeeScript is preferred but JavaScript can also be `require`'d. Modules should be small, reusable and written in the [CommonJS](http://www.commonjs.org/) format.
Here's some example usage of 2 different modules:

`app/source/coffeescripts/ui-callbacks.coffee`

```
{Search} = require '../wrappers/search.coffee'

@onEnterSearch = (event) ->
  new Search {event}
```

`app/source/coffeescripts/event-handlers.coffee`

```
{onEnterSearch} = require './ui-callbacks.coffee'

$('#search').on 'click', onEnterSearch
```

## Images and Fonts
Prefix image and font filenames with the prefix defined by `PROJECT_PREFIX` in `harness/env.sh` for deployment ease.
Built assets will also use this prefix so that `make deploy` can just glob `app/public/PROJECT_PREFIX*`.

---

## API Mocks
`harness` makes it really easy to test your UI against specific data sets returned from an API.
You're free to hit actual remote endpoints if you want, but `harness` makes it very easy to save and reproduce edge-case API responses locally.
API mocks also make the integration tests fast, because API calls are local to the `harness` server.


## Deployment
Deployment is a bit different than in the usual sense. `harness` can "deploy" to any directory on your local file system.
This makes it very easy to deploy your latest build to another local repo, like a Rails app for example.


## Integration
Include the output assets in `public/` and create 2 new files for integration points with a server-side application:

__`.js` file for configuration and instantiation__
  - Allows configuration to be passed in from the server
  - Discourages auto-instantiation

__`.css` file for image and font rules and any necessary style overrides__
  - Allows image and font assets to be served up via the server caching strategies
  - Smooths out style differences post-integration
