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

exports.incrementPlayerScore = functions.firestore
  .document('gamesessions/{sessionId}/scores/{playerId}')
  .onUpdate(async (change, context) => {
    const newScore = change.after.data().score + 500;

    const sessionRef = admin.firestore().doc(`gamesessions/${context.params.sessionId}`);
    const playerRef = sessionRef.collection('scores').doc(context.params.playerId);

    try {
      await playerRef.update({ score: newScore });
      console.log(`Player ${context.params.playerId} score updated to ${newScore}`);
    } catch (error) {
      console.error('Error updating player score:', error);
    }
  });




