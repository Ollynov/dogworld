import * as functions from 'firebase-functions';
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



const scrapeMetaTags = (text: any) => {
  // This cheerio method here is fast and easy, but it does not get data that is rendered after the fact by javascript. So for many websites, such as any that use react, this really won't work at all.
  const urls = Array.from( getUrls(text) );
  const requests = urls.map(async url => {
    const res = await fetch(url);
    const html = await res.text();
    const $ = cheerio.load(html);

    const getMetatag = (name: any) =>  
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

export { helloWorld, scrapeDogTime }