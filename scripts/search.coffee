send_with_google = (msg, path, query = {}) ->
  msg.http(path).query(query).get() (err, res, body) ->
    json = JSON.parse body
    if json.items.length > 0
      items = json.items[0]
      msg.send "#{items[0].link}"


module.exports = (robot) ->
  robot.respond /(.*?) 検索して/i, (msg) ->
    msg.send '検索するよ'
    keyword = msg.match[1]
    send_with_google msg, 'https://www.googleapis.com/customsearch/v1', {key: process.env.HUBOT_GOOGLE_CSE_KEY, cx: process.env.HUBOT_GOOGLE_CSE_ID, q: keyword, safe: 'high'}
