request = require 'request'
chardet = require 'jschardet'
iconv = require 'iconv-lite'

module.exports = (url, callback) ->
  buffer = new Buffer 0
  req = request.get url, agent: false, timeout: 10 * 1000, headers: {'User-Agent': 'fetch-title'}
  req.on 'error', (err) ->
    console.log err.stack
  req.on 'response', (res) ->
    if res.statusCode is 200 and res.headers['content-type']?.match /text\/html/
      charset = res.headers['content-type'].match(/charset=([\w\-]+)/)?[1]
      res.on 'data', (chunk) ->
        buffer = Buffer.concat [buffer, chunk]
      res.on 'end', ->
        if not (charset in ['utf-8', 'shift_jis', 'euc-jp'])
          charset = chardet.detect buffer
          if charset.confidence * 100 < 60
            charset = 'UTF-8'
          else
            charset = charset.encoding
        if charset.toUpperCase() is 'UTF-8'
          body = buffer.toString()
        else
          body = iconv.decode buffer, charset
        title = body.match(/<title.*?>(.*?)<\/title>/i)?[1]
        description = body.match(/meta name="description" content="(.*?)"/im)?[1]
        callback title, description, url
    else
      do req.abort
      callback null, null, url
  do req.end
