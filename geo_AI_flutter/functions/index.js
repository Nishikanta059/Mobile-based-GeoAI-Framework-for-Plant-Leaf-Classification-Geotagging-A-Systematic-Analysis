const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();


exports.makeUppercase = functions.firestore.document('/leaves/{documentId}')
    .onCreate((snap, context) => {

      const original = snap.data().original;


      functions.logger.log('Uppercasing', context.params.documentId, original);

      const uppercase = original.toUpperCase();


      return snap.ref.set({uppercase}, {merge: true});
    });