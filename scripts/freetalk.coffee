#description:
#   DOCOMOの雑談APIを利用した雑談
#
# Author:
#   FromAtom

getTimeDiffAsMinutes = (old_msec) ->
  now = new Date()
  old = new Date(old_msec)
  diff_msec = now.getTime() - old.getTime()
  diff_minutes = parseInt( diff_msec / (60*1000), 10 )
  return diff_minutes

module.exports = (robot) ->
  robot.respond /さん(?:、)?\s*(.*)/, (msg) ->
    DOCOMO_API_KEY = process.env.DOCOMO_API_KEY
    message = msg.match[1]
    user_name = msg.message.user.name
    return unless DOCOMO_API_KEY && message

    ## ContextIDを読み込む
    KEY_DOCOMO_CONTEXT = 'docomo-talk-context#{user_name}'
    context = robot.brain.get KEY_DOCOMO_CONTEXT || ''

    ## modeを読み込む
    KEY_DOCOMO_MODE = ''
    mode = robot.brain.get KEY_DOCOMO_MODE || ''

    ## 前回会話してからの経過時間調べる
    KEY_DOCOMO_CONTEXT_TTL = 'docomo-talk-context-ttl#{user_name}'
    TTL_MINUTES = 20
    old_msec = robot.brain.get KEY_DOCOMO_CONTEXT_TTL
    diff_minutes = getTimeDiffAsMinutes old_msec

    ## 前回会話してから一定時間経っていたらコンテキストを破棄
    if diff_minutes > TTL_MINUTES
      context = ''
      mode = ''

    url = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=' + DOCOMO_API_KEY
    request = require('request');
    request.post
      url: url
      json:
        utt: message
        nickname: user_name if user_name
        sex: '男'
        mode: mode if mode
        context: context if context
      , (err, response, body) ->
        ## ContextIDの保存
        robot.brain.set KEY_DOCOMO_CONTEXT, body.context

        ##モードの保存
        robot.brain.set KEY_DOCOMO_MODE, body.mode

        ## 会話発生時間の保存
        now_msec = new Date().getTime()
        robot.brain.set KEY_DOCOMO_CONTEXT_TTL, now_msec	

        msg.send body.utt
