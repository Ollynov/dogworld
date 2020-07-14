
const functions = require('firebase-functions');
// import * as admin from 'firebase-admin';
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

    const getAttributes = () => {
      const base = $(".characteristic-stars");
      let attributes = {};

      for (var i in base) {
        if (base[i] && base[i].children && base[i].children[0] && base[i].children[1]) {
          let first = base[i].children[0];
          let second = base[i].children[1];
          if (first.children && first.children[1] && second.children && second.children[0].children) {
            var attribute = first.children[1].data;
            var score =  second.children[0].children[0].data;

            attributes[attribute] = score;
          }
        }
      }
      return attributes;
    }

    return {
      url, 
      title: $('title').first().text,
      favicon: $('link[rel="shortcut icon"]').attr('href'),
      description: getMetatag('description'),
      attributes: getAttributes()
    }
  });

  return Promise.all(requests);

}

const scrapeDogTime = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    // wrapping our function in cors ensures that we can properly call it from any frontend application;
    if (Object.keys(req.body).length === 0 && req.body.constructor === Object) {
      res.send("No urls provided")

    } else {
      // const body = JSON.parse(req.body);
      // console.log('here is our body: ', body)

      // this is taking the text from our frontend, where we will indicate which urls we want to scrape
      const data = await scrapeMetaTags(req.body.text);
      res.send(data)
    }

  })
  
});

module.exports = {
  helloWorld, 
  scrapeDogTime
}