const got = require('got');
const jschardet = require('jschardet');
const iconv = require('iconv-lite');
const jsdom = require('jsdom').JSDOM;

module.exports = (url) => {
  return new Promise((resolve, reject) => {
    got(url, { encoding: null, timeout: 7000 }).then((response) => {
      if (response.statusCode === 200) {
        const contentType = response.headers['content-type'];
        if (contentType.includes('text/html')) {
          let charset = /charset=([\w-]+)/.exec(contentType);
          charset = charset ? charset[1].toLowerCase() : null;
          const body = (charset === 'utf-8') ? response.body.toString() : iconv.decode(response.body, jschardet.detect(response.body).encoding);
          const dom = new jsdom(body);
          resolve(dom.window.document.title);
          dom.window.close();
        } else {
          reject(new Error('This is not HTML.'));
        }
      } else {
        reject(new Error(response.statusCode));
      }
    }).catch((error) => {
      reject(new Error(error));
    });
  });
};
