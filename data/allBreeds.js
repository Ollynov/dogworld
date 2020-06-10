const admin = require('firebase-admin');
const fs = require('fs-extra');
// const yaml = require('yamljs');

admin.initializeApp({
    credential: admin.credential.cert(require('./credentials.json')),
});
const db = admin.firestore();

// const topics = [
//     'angular',
//     'flutter',
//     'cf',
//     'firebase',
//     'firestore',
//     'flutter',
//     'rxjs',
//     'js',
//     'ts'
// ]


const update = async() => {

    const json = require("./breeds/allBreeds.json");


    json.dogs.forEach(async (breed) => {
      
      const ref = db.collection('allBreeds').doc(breed);
      await ref.set({
        name: breed,
      }, { merge: true });
    })



    console.log('DONE');

}

update();

// for (const topic of topics) {
//     update(topic);
// }



