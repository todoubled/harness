# Harness

Tools for writing HTML, CSS, and JavaScript with unit and integration testing, dependency management, deployment and API mocks.

`harness` was created out of the need to develop JavaScript apps independently of the server stack that is used in production.
Write an app with `harness` and deploy it to any host web app.
`harness` apps have their own unit and integration test suite.


### Testing
Testing is covered on both a unit and integration level.
Jasmine unit tests are run with [testem](https://github.com/airportyh/testem) and integration tests are run with [casper.js](http://casperjs.org).


### Dependency Management
Dependencies are managed with [`browserify`](https://github.com/substack/node-browserify).


### Deployment
Deployment is a bit different than the usual sense. `harness` can "deploy" to any directory on your local file system.
This makes it very easy to deploy your latest build to another repo on your filesystem, like a Rails app for example.


### API Mocks
`harness` makes it really easy to test your UI against specific data sets returned from an API.
You're free to hit actual remote endpoints if you want, but `harness` makes it very easy to save and reproduce edge-case API responses locally.
API mocks also make the integration tests fast, because API calls are local to the `harness` server.

---

`harness` is a set of scripts and tasks for building JavaScript applications. It's meant to ease development of small client-side applications that can be embedded in larger server-side applications.

The goal is to surpass the niceties of writing client-side code within the development harness of a server-side codebase (asset preprocessing, templating, testing, rapid integration, etc.),
making it easy to __work independently in a separate codebase__.


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


## Features
__Auto-running unit tests in all browsers with [`jasmine`](http://pivotal.github.com/jasmine/) and [`testem`](https://github.com/airportyh/testem)__
  - Unit tests are auto-run in any browser currently opened to `localhost:7357` every time a source or test file changes

__Headless integration tests in Webkit with [`casperjs`](http://casperjs.org/)__
  - Integration tests are run every time a source or test file changes

__Documentation with [`groc`](https://github.com/nevir/groc)__
  - Inline comments with markdown are parsed and displayed as HTML documentation

__Browser auto-refresh with [`live-reload`](https://github.com/livereload/livereload-extensions)__
  - Page is refreshed in any browser currently opened to `localhost:8080` every time a source file changes

__Dependency management with [`browserify`](https://github.com/substack/node-browserify)__
  - Modularize, prevent global leakage, and control module dependencies

__I18n (build for each locale) with [`jed`](https://github.com/SlexAxton/Jed)__
  - Suboptimal. Currently requires a build for each locale

__Endpoint mocks with [`express`](http://expressjs.com/)__
  - Mock out server endpoints with sample responses that mimic production

__Deployment to filesystem__
  - `make deploy` accepts an `OUTPUT` variable to `cp` the output assets to another codebase on the filesystem

__Support for various versions of dependencies with query string parameters__
  - Test the app against new and old versions of Backbone or jQuery during development with query string parameters


## Collateral Benefits
__App/Platform independent__
  - Embeddable for any app in any country on any platform, providing the configuration and endpoints are defined

__Runtime dependency independent__
  - Use any dependencies you want -- backbone.js, ember.js or fuckit.js

__Clear and defined integration points__
  - Forces upfront thought to define the boundaries and interfaces for client-side code

__Less global impact__
  - Reduce the reliance on super objects

__Fast and transparent tests__
  - Run automatically on every file change so test setup is painless
  - Early detection of regressions

__[Github Flow](http://scottchacon.com/2011/08/31/github-flow.html) compatible__
  - Pull Requests, implementation discussion and accountable code reviews

__Developer happiness__
  - Fewer concerns and with the grain
  - Familiar and non-hostile tools


# Dependencies
- gcc: install via Xcode
- [node.js 0.8.8+](http://nodejs.org/dist/v0.8.8/node-v0.8.8.pkg)
- pygments: `sudo easy_install pygments`
- casper.js: `brew install casperjs`

`make install` to install dependencies after a fresh clone.
---


## Workflow
`make server` starts file watchers for `src/` and `/test` and a server at `http://localhost:8080` for development.

`make test` to run the tests at `http://localhost:7357` in all open browsers every time a source or test file is changed.

`make itest` to run the integration tests every time a source or test file is changed.

`make deploy OUTPUT=/path/to/www` to make a build and `cp public/prefix*` a directory of your choosing.
---
