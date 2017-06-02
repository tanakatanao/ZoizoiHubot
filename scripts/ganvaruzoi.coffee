# Commands:
#   今日も一日 - ランダムでが[んばるぞい]の文字列が生成される。


# arrayをシャッフルする関数
shuffle = (array) ->
  i = array.length
  if i is 0 then return false
  while --i
    j = Math.floor Math.random() * (i + 1)
    tmpi = array[i]
    tmpj = array[j]
    array[i] = tmpj
    array[j] = tmpi
  return


module.exports = (robot) ->
  robot.hear /今日も一日/i, (msg) ->
    # この中で処理を書く
    name = msg.match[1] # () の中が取れる
    arr = ['ん','ば','る','ぞ','い']
    shuffle arr
    str = "が#{arr.join("")}"
    switch str
      when 'がんばるぞい'
        msg.send str # 発言をする
        msg.send 'http://livedoor.blogimg.jp/jin115/imgs/a/f/afed00c3.jpg'
      when 'がるばんぞい'
        msg.send str
        msg.send 'http://foodsnews.com/photos/080822-40-06.jpg'
      else 
        msg.send str

  robot.hear /明日も一日/i, (msg) ->
        msg.send 'がんばるぞい' # 発言をする
        msg.send 'http://livedoor.blogimg.jp/jin115/imgs/a/f/afed00c3.jpg'

  robot.hear /今日もー日/i, (msg) ->
        msg.send 'がるばんぞい'
        msg.send 'http://foodsnews.com/photos/080822-40-06.jpg'
        
  robot.hear /zoi (.*)/i, (msg) ->
        msg.send "@#{msg.match[1]} https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQV_GUViX6wFWeQlEoEv-L4KUQa0xHD9f_Vy9D-we5qoZ_IzLbP"
