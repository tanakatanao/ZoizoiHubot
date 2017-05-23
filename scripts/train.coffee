arrify = require('arrify')
dateFormat = require('dateformat')
request = require('request')
# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob

module.exports = (robot) ->
  robot.respond /(.*)線/i, (msg) ->
    request.get("https://rti-giken.jp/fhc/api/train_tetsudo/delay.json", (error,response,body) ->
      if error or response.statusCode != 200
        return msg.send('失敗だぞい')
      data = JSON.parse(body)
      trainName = "#{msg.match[1]}線"
      for kobetu in data
        if kobetu.name is trainName
          msg.send "#{trainName}は遅延しているぞい"
          return msg.send "https://transit.yahoo.co.jp/traininfo/search?q=#{trainName}"
      msg.send "#{trainName}は遅延していないぞい")

  send = (channel, msg) ->
    robot.send {room: channel}, msg

  checkTrainDelay = ->
    request.get("https://rti-giken.jp/fhc/api/train_tetsudo/delay.json", (error,response,body) ->
      if error or response.statusCode != 200
        return send '#test',"error発生"
      data = JSON.parse(body)
      trainName_ChuoSobuKakutei = "中央･総武各駅停車"
      trainName_KeiyoSen = "京葉線"
      trainName_MusashinoSen = "武蔵野線"
      for kobetu in data
        if kobetu.name is trainName_ChuoSobuKakutei
          send '#general',"中央･総武各駅停車が遅延しているぞい"
          return send '#general',"https://transit.yahoo.co.jp/traininfo/detail/40/0/"
        if kobetu.name is trainName_KeiyoSen
          send '#general',"京葉線が遅延しているぞい"
          return send '#general',"https://transit.yahoo.co.jp/traininfo/detail/69/0/"
        if kobetu.name is trainName_MusashinoSen
          send '#general',"武蔵野線が遅延しているぞい"
          return send '#general',"https://transit.yahoo.co.jp/traininfo/detail/71/0/"
        return)

  new cronJob('0 30 7 * * 1-5', () ->
    checkTrainDelay()
  ).start

  new cronJob('0 0 8 * * 1-5', () ->
    checkTrainDelay()
  ).start

  new cronJob('0 0 17 * * 1-5', () ->
    checkTrainDelay()
  ).start

  new cronJob('0 30 17 * * 1-5', () ->
    checkTrainDelay()
  ).start

  new cronJob('0 0 18 * * 1-5', () ->
    checkTrainDelay()
  ).start

