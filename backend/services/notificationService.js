/**
 * notificationService.js
 * Wraps firebase-admin FCM messaging.
 * Gracefully disabled if FIREBASE_SERVICE_ACCOUNT env var is not set.
 */

let admin    = null;
let messaging = null;

// ── #10 : Nettoyage des tokens FCM invalides en base ─────────────────────────
// Appelé après une erreur NotRegistered / InvalidRegistration.
async function _clearStaleToken(token) {
  try {
    const { User } = require('../models');
    await User.update({ fcmToken: null }, { where: { fcmToken: token } });
    console.warn('[FCM] Token invalide supprimé de la base :', token.slice(0, 20) + '…');
  } catch (err) {
    console.error('[FCM] Impossible de supprimer le token invalide :', err.message);
  }
}

function init() {
  const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT;
  if (!serviceAccountJson) {
    console.warn('[FCM] FIREBASE_SERVICE_ACCOUNT not set — push notifications disabled.');
    return;
  }

  try {
    const firebaseAdmin = require('firebase-admin');
    if (!firebaseAdmin.apps.length) {
      const serviceAccount = JSON.parse(serviceAccountJson);
      firebaseAdmin.initializeApp({
        credential: firebaseAdmin.credential.cert(serviceAccount),
      });
    }
    admin = firebaseAdmin;
    messaging = firebaseAdmin.messaging();
    console.log('[FCM] Firebase Admin initialized.');
  } catch (err) {
    console.error('[FCM] Failed to initialize Firebase Admin:', err.message);
  }
}

/**
 * Send a notification to a single FCM token.
 * @param {string} token - Device FCM token
 * @param {string} title - Notification title
 * @param {string} body  - Notification body
 * @param {object} data  - Optional key/value data payload (all values must be strings)
 */
async function sendToToken(token, title, body, data = {}) {
  if (!messaging || !token) return;
  try {
    const stringData = {};
    for (const [k, v] of Object.entries(data)) stringData[k] = String(v);

    await messaging.send({
      token,
      notification: { title, body },
      data: stringData,
      android: {
        notification: {
          channelId: 'foot_amateur_default',
          priority: 'high',
          sound: 'default',
        },
      },
    });
  } catch (err) {
    // InvalidRegistration / NotRegistered → token périmé : supprimer de la base
    if (err.code === 'messaging/invalid-registration-token' ||
        err.code === 'messaging/registration-token-not-registered') {
      _clearStaleToken(token); // fire-and-forget
    } else {
      console.error('[FCM] sendToToken error:', err.message);
    }
  }
}

/**
 * Send to a list of tokens (best-effort; errors per token are swallowed).
 */
async function sendToTokens(tokens, title, body, data = {}) {
  if (!messaging || !tokens || !tokens.length) return;
  const valid = tokens.filter(Boolean);
  if (!valid.length) return;
  await Promise.all(valid.map(t => sendToToken(t, title, body, data)));
}

module.exports = { init, sendToToken, sendToTokens };
