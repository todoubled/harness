# ## Environment Variables
#
# Configure scripts with custom paths and other settings.
#
# - `PROJECT_PREFIX` is used for globbing on deployment and generating built asset filenames.
# - `CASPER_HELPERS` augments the helpers in `harness/casper-helpers.coffee` with your own for more succint integration tests.
#
export PATH="./node_modules/.bin:$PATH"
export PROJECT_PREFIX="example-app"
export CASPER_HELPERS=""

exec "$@"
