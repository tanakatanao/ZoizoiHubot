request = require('request')
dateFormat = require('dateformat')

module.exports = (robot) ->
  robot.respond /めし\s*(.*)?$/i, (msg) ->
    freeword = msg.match[1]
    keyid = process.env.HUBOT_GURUNAVI_APP_ID
    format = 'json'
    lunch = '0'
    areacode_s = process.env.HUBOT_GURUNAVI_AREACODE_S
    hit_per_page = '500'
    options = 
      #url: "https://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=#{keyid}&format=#{format}&lunch=#{lunch}&areacode_s=#{areacode_s}&freeword=#{freeword}"
      #とりあえず海浜幕張駅付近の店全部持ってくる
      url: "https://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=#{keyid}&format=#{format}&lunch=#{lunch}&areacode_s=#{areacode_s}&hit_per_page=#{hit_per_page}"
      method: 'GET'
      #json: true

    request options, (error, response, body) ->
      #レスポンスコードが200以外だったらエラー吐く
      if error or response.statusCode != 200
        return  msg.send "response error : #{response.statusCode}"
      data = JSON.parse(body)
      
      #デバッグ用
      #msg.send data.total_hit_count
      #msg.send body
      #レスポンスのカテゴリと入力をマッチさせて、配列にぶちこむ
      shoparr = []
      for kobetu in data.rest
        try
          if kobetu.category.match(///^#{freeword}///i)?
            shoparr.push(kobetu)
        catch e
          console.log e.name
          console.log e.message
          

      hits = shoparr.length

      if hits is 0
        return msg.send 'お店が見つかんないぞい'
  
      if hits is '1'
        return msg.send "#{shoparr.name}はいかがですぞい？\n#{shoparr.url}"
  
      random = Math.floor(Math.random()*hits)
      return msg.send "#{shoparr[random].name}はいかがですぞい？\n#{shoparr[random].url}"






