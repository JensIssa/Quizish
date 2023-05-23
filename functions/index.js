const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp({projectId: 'quizish-ee75f'});

const firestore = admin.firestore();


exports.incrementCurrentQuestion = functions.firestore
  .document('gameSessions/{sessionId}')
  .onUpdate((change, context) => {
    const newCurrentQuestion = admin.firestore.FieldValue.increment(1);
    const sessionRef = firestore.collection('gameSessions').doc(context.params.sessionId);
    return sessionRef.update({ currentQuestion: newCurrentQuestion });
  });



