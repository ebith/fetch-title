fetchTitle = require './index.coffee'
assert = require('chai').assert

describe 'レスポンスヘッダに文字コードを含むページ', ->
  it 'UTF-8 (はてな)', (done) ->
    fetchTitle 'http://www.hatena.ne.jp/', (title) ->
      assert.ok title, 'はてな'
      do done
  it 'Shift_JIS (2ch.sc)', (done) ->
    fetchTitle 'http://2ch.sc/', (title) ->
      assert.ok title, '２ちゃんねる掲示板へようこそ'
      do done

describe 'レスポンスヘッダに文字コードを含まないページ', ->
  it 'UTF-8 (ニコニコ動画)', (done) ->
    fetchTitle 'http://www.nicovideo.jp/', (title) ->
      assert.ok title, 'ニコニコ動画'
      do done
  it 'Shift_JIS (任天堂)', (done) ->
    fetchTitle 'http://www.nintendo.co.jp/', (title) ->
      assert.ok title, '任天堂ホームページ'
      do done
  it 'EUC-JP (4Gamer.net)', (done) ->
    fetchTitle 'http://www.4gamer.net/', (title) ->
      assert.ok title, '4Gamer.net ― 日本最大級の総合ゲーム情報サイト。最新ゲームのニュース，レビューはここで！'
      do done

describe '過去に文字化けしたページ', ->
