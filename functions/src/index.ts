import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
const cors = require("cors")({origin: true})
const cheerio = require('cheerio');
const getUrls = require('get-urls');
const fetch = require('node-fetch');
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
const helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!!!!!");
});

const scrapeDogTime = functions.https.onRequest((req, res) => {

  
});

const scrapeMetaTags = (text) => {
  // This cheerio method here is fast and easy, but it does not get data that is rendered after the fact by javascript. So for many websites, such as any that use react, this really won't work at all.
  const urls = Array.from( getUrls(text) );
  const requests = urls.map(async url => {
    const res = await fetch(url);
    const html = await res.text();
    const $ = cheerio.load(html);

    const getMetatag = (name) =>  
            $(`meta[name=${name}]`).attr('content') ||  
            $(`meta[name="og:${name}"]`).attr('content') ||  
            $(`meta[name="twitter:${name}"]`).attr('content');

    return {
      url, 
      title: $('title').first().text,
      favicon: $('link[rel="shortcut icon"]').attr('href'),
      description: getMetatag('description'),
      image: getMetatag('image'),
      author: getMetatag('author'),
    }
  });

  return Promise.all(requests);

}

export { helloWorld, scrapeDogTime }