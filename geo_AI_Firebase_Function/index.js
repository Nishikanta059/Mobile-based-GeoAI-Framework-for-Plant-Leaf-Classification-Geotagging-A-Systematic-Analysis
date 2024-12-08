const functions = require("firebase-functions");
const admin = require('firebase-admin');

var serviceAccount = require("./ser.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});



const {Storage} = require('@google-cloud/storage');
const { log } = require("firebase-functions/logger");

var storage = new Storage({
  projectId: "drdo-leaf",
  keyFilename:"./ser.json"
});

const myBucket = storage.bucket('gs://drdo-leaf.appspot.com/');

exports.processImage = functions.firestore.document('/leaves/{documentId}')
    .onCreate(async (snap, context) => {
     var documentId=context.params.documentId;

     console.log(documentId+'function triggered');

     var mlApiLinkDoc=await (await admin.firestore().doc('apiLinks/mlLocalHost').get()).data();
var leafDoc=snap.data();

var imglink=leafDoc.image;


console.log(documentId+'function triggered');

var apiLink=mlApiLinkDoc["link"];
var isActive=mlApiLinkDoc["isActive"];

console.log('image link'+imglink);
console.log('Api link'+apiLink);


var formdata = new FormData();

const file = myBucket.file('maskedLeaves/leaf'+documentId+'.png');

formdata.append("link", imglink);
var requestOptions = {
  method: 'POST',
  body: formdata,
  redirect: 'follow'
};
fetch(apiLink, requestOptions)
  .then(async response => {
   await response.blob().then(async blobResponse => {
    const disposition = response.headers.get('content-disposition');
   const writableStream = file.createWriteStream({
    metadata: {
      contentType: 'image/png',
    },
  });
  const buffer = Buffer.from(await blobResponse.arrayBuffer());
  writableStream.end(buffer);
  writableStream.on('finish',async () => {
  const [url] = await file.getSignedUrl({
    action: 'read',
    expires: '03-17-2024',
  }).catch(error => console.log('error', error));
  console.log(`Download URL: ${url}`);
  const docRef = admin.firestore().collection('leaves').doc(documentId);
  const updateData = {
    isProcessed:true,
    maskedImage:url,
    className:disposition,
  };

  await docRef.update(updateData);
  console.log('Document updated successfully!');
  console.log(`Fileuploaded to Firebase Storage.`);

  });
    })
  })
  .catch(error => console.log('error', error));
    
   console,log('asdsadsa '+documentId)
    });