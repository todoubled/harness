casper.readCookie = (page, key) ->
  # cookie =
  #   domain: 'localhost'
  #   expires 'timestamp'
  #   expiry: milliseconds
  #   httponly: false
  #   name: ''
  #   path: '/'
  #   secure: false
  #   value: ''
  cookie = page.cookies[0]
  cookie[key]


casper.decodeResourceUrl = (resource, division, dealTypes) ->
  url = decodeURIComponent resource.url
  return false unless url.match(division) && url.match(dealTypes)
  true


casper.getCookieValue = (page) -> decodeURIComponent(@readCookie(page, 'value')).split '|'
casper.on 'run.start', -> @page.clearCookies()
casper.on 'run.complete', -> @evaluate -> window.location.hash = ''
