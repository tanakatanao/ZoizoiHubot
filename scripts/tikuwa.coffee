module.exports = (robot) ->
  robot.respond /ちくわぶ/i, (msg) ->
    # この中で処理を書く
    msg.send 'メンテ中だぞいい'
    
