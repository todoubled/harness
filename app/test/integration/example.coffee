casper.test.comment 'Displays Hello World'
casper.start 'http://localhost:8081', ->
  @test.assertTitle 'Harness Example', 'harness example is the expected page'

casper.run ->
  @test.done()
  @reload()
