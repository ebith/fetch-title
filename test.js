const assert = require('assert');
const fetchTitle = require('./index.js');

describe('レスポンスヘッダに文字コードを含むページ', () => {
  it('UTF-8 (はてな)', (done) => {
    fetchTitle('http://www.hatena.ne.jp/').then((title) => {
      assert.strictEqual(title, 'はてな');
      done();
    });
  });
  it('Shift_JIS (2ch.sc)', (done) => {
    fetchTitle('http://2ch.sc/').then((title) => {
      assert.strictEqual(title, '２ちゃんねる掲示板へようこそ');
      done();
    });
  });
});

describe('レスポンスヘッダに文字コードを含まないページ', () => {
  it('UTF-8 (任天堂)', (done) => {
    fetchTitle('https://www.nintendo.co.jp/').then((title) => {
      assert.strictEqual(title, '任天堂ホームページ');
      done();
    });
  });
  it('EUC-JP (4Gamer.net)', (done) => {
    fetchTitle('http://www.4gamer.net/').then((title) => {
      assert.strictEqual(title, '4Gamer.net ― 日本最大級の総合ゲーム情報サイト。最新ゲームのニュース，レビューはここで！');
      done();
    });
  });
});
