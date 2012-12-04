# ## Casper.js Integration Test Helpers
#
# ###### Define convenience methods and prevent test pollution
#
# ---
#


casper.readCookie = (page, key) ->
  # Cookie object attributes for reference:
  #
  # ```
  # domain: string
  # expires string
  # expiry: number
  # httponly: boolean
  # name: string
  # path: string
  # secure: boolean
  # value: string
  # ```
  #
  cookie = page.cookies[0]
  cookie[key]



casper.decodeResourceUrl = (resource, division, dealTypes) ->
  url = decodeURIComponent resource.url
  return false unless url.match(division) && url.match(dealTypes)
  true



#
# ###### Get just the value segment of the cookie.
#
casper.getCookieValue = (page) ->
  decodeURIComponent(@readCookie(page, 'value')).split '|'



#
# ###### Clear cookies before the test run starts to avoid pollution.
#
casper.on 'run.start', ->
  @page.clearCookies()



#
# ###### Reset the URL hash after each test run completes to avoid pollution.
#
casper.on 'run.complete', ->
  @evaluate ->
    window.location.hash = ''
