arrify = require('arrify')
dateFormat = require('dateformat')

weathearAreaList = require('../config/weather_area_list.json')

module.exports = (robot) ->
  robot.respond /天気\s*(.*)?$/i, (msg) ->
    place = msg.match[1] or '東京'
    city = null
    weathearAreaList.some (area) ->
      arrify(area.city).some (data) ->
        if data.title == place
          city = data
        return false
    
    unless city
      msg.send "#{place}の天気は見つかりませんぞい"
      return

    # livedoor 天気予報APIのバグ arealistのIDが5桁のものは0パディングしないといけない
    cityId = "0#{city.id}".slice(-6)

    msg
      .http('http://weather.livedoor.com/forecast/webservice/json/v1')
      .query(city: cityId)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send('天気の取得に失敗しましたぞい')
          return
        result = JSON.parse(body)
        forecastTime = new Date(result.publicTime)
        msg.send "【お天気情報 #{place}】\n" +
        "■  #{dateFormat(forecastTime, "yyyy年mm月dd日HH時MM分")}の予報ですぞい\n" +
        "予報 : #{result.forecasts[0].telop}\n" +
        "#{result.description.text}\n" +
        "詳しい情報は下記を参照\n\n" +
        "#{result.link}"
