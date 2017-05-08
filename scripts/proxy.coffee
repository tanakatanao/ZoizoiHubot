proxy = require 'proxy-agent'
module.exports = (robot) ->
  robot.globalHttpOptions.httpAgent  = proxy('http://132.222.121.98:8080', false)
  robot.globalHttpOptions.httpsAgent = proxy('http://132.222.121.98:8080', true)
