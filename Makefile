#
# ## Development Tasks
#
# ###### Shortcuts to scripts with common configuration.
#
.PHONY: test docs


#
# #### `make deploy OUTPUT=/absolute/path/to/rails/app`
#
# ###### "Deploy" in the sense of copying built assets into another local app repository
#
deploy :
	make release
	./harness/env.sh coffee harness/deploy
# ---


#
# #### `make docs`
#
# ###### Generate documentation from inline comments in the source CoffeeScript files.
#
docs :
	./harness/env.sh groc -e "./node_modules/**/*" "./**/*.coffee" README.md
# ---


#
# #### `make install`
#
# ###### Install all npm dependencies.
#
install :
	./harness/env.sh npm install
# ---


#
# #### `make itest`
#
# - Create a fresh build and start up the development server at `localhost:8081`.
# - Use [casper.js](http://casperjs.org/) to browse the app headlessly and run integration tests.
# - Simulate clicking, form filling, and URL manipulation.
# - Assert cookie values, URL values, and UI values.
#
itest :
	make build
	./harness/env.sh coffee harness/start integration-tests
# ---



#
# #### `make server`
#
# - Primary development task
# - Start up a file watcher to run `make build` each time a source file changes.
# - Start up a web server to respond to mock API requests at `localhost:8080`.
# - Start up a `livereload` instance to refresh the browser each time a file changes (Chrome extension required).
#
server :
	./harness/env.sh coffee harness/start development-server
# ---


#
# #### `make test`
#
# - Create a fresh build
# - Start up a testem instance that reruns all tests each time a source or test file changes.
# - Tests are run automatically in all browsers currently opened to `localhost:7357`.
#
test :
	make build
	./harness/env.sh testem -f harness/testem.json app/test
# ---


build :
	./harness/env.sh coffee harness/build


release :
	NODE_ENV=release make build
	echo "//Generated by https://github.com/todoubled/harness"|cat - ./app/public/$PROJECT_PREFIX.js > /tmp/out && mv /tmp/out ./app/public/$PROJECT_PREFIX.js
	echo "/*Generated by https://github.com/todoubled/harness*/"|cat - ./app/public/$PROJECT_PREFIX.css > /tmp/out && mv /tmp/out ./app/public/$PROJECT_PREFIX.css


watch :
	./harness/env.sh watchman app/source "make build"


webserver :
	./harness/env.sh coffee harness/server
