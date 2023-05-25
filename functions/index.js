const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp({projectId: 'quizish-ee75f'});

const firestore = admin.firestore();

exports.incrementScore = functions.https.onCall(async (data, context) => {
  const { sessionId, userId } = data;
  try {
    // Fetch the gameSession document
    const sessionRef = firestore.collection('gameSessions').doc(sessionId);
    const sessionDoc = await sessionRef.get();

    // Check if the gameSession document exists
    if (!sessionDoc.exists) {
      throw new Error('Game session does not exist');
    }
    // Get the current score for the specified user
    const sessionData = sessionDoc.data();
    const scores = sessionData.scores || {};
    const currentScore = scores[userId] || 0;
    // Increment the score by 500
    const newScore = currentScore + 500;
    // Update the score in the gameSession document
    await sessionRef.update({ [`scores.${userId}`]: newScore });

    return { success: true, newScore };
  } catch (error) {
    console.error('Error incrementing score:', error);
    return { success: false, error: error.message };
  }
});








