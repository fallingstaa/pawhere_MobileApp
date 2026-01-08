/**
 * Firebase Cloud Functions - Secure Traccar API Proxy
 * GOAL:
 * 1. Verify Firebase Authentication ID Token on all proxied requests.
 * 2. Use admin-level Traccar credentials (stored in env vars) to establish a backend session.
 * 3. Proxy Traccar API calls securely through this session.
 *
 * NOTE: This is a TEMPORARY structure. In the final version, the Firebase user's linked
 * devices would be fetched from Firestore, and the Traccar API calls would be limited
 * to only those devices. For now, it establishes a secure channel.
 *
 * DEPLOY (from functions directory):
 * npm install express axios cors firebase-admin
 * // Ensure you set TRACCAR_EMAIL and TRACCAR_PASSWORD via firebase functions:config:set or a .env file
 * firebase deploy --only functions:api
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { defineString } = require('firebase-functions/params');
const express = require('express');
const axios = require('axios');
const cors = require('cors');

// Initialize Firebase Admin SDK (required for Auth verification)
// Use the default app credentials
if (admin.apps.length === 0) {
    admin.initializeApp();
}

// Params (loaded from .env or from deployment-time environment)
// These are the Traccar user credentials that have access to all linked devices.
const TRACCAR_EMAIL_PARAM = defineString('TRACCAR_EMAIL');
const TRACCAR_PASSWORD_PARAM = defineString('TRACCAR_PASSWORD');

// Traccar base URL (can be moved to environment config in production)
const TRACCAR_BASE_URL = process.env.TRACCAR_BASE_URL || 'http://demo4.traccar.org/api';

const app = express();

// Basic middlewares
app.use(cors({ origin: true }));
app.use(express.json()); // Parse JSON bodies

// Global in-memory session store (TEMP: WILL BE REPLACED BY FIRESTORE/REDIS)
// Key: 'traccar_session' -> Value: JSESSIONID cookie string
let traccarSessionCookie = null;
let lastLoginAttempt = 0;
const SESSION_LIFETIME = 30 * 60 * 1000; // 30 minutes

/**
 * Middleware to verify Firebase ID Token from the client.
 * Puts the decoded token (which contains the Firebase user's uid) on the request.
 */
const authenticateFirebaseUser = async (req, res, next) => {
    // Check for authorization header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ error: 'Unauthorized: No or invalid Authorization header' });
    }

    // Extract the token
    const idToken = authHeader.split('Bearer ')[1];

    try {
        // Verify the ID token using the Firebase Admin SDK
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        // Attach user info to the request for downstream handlers
        req.user = decodedToken; 
        next();
    } catch (error) {
        console.error('Error verifying Firebase ID token:', error.code, error.message);
        return res.status(401).json({ error: 'Unauthorized: Invalid Firebase ID token' });
    }
};

/**
 * Helper to ensure a valid Traccar session cookie exists on the backend.
 * Uses the admin credentials defined in environment variables.
 */
const ensureTraccarSession = async () => {
    const now = Date.now();
    
    // Check if the current session is still considered valid
    if (traccarSessionCookie && (now - lastLoginAttempt < SESSION_LIFETIME)) {
        return traccarSessionCookie;
    }

    const email = TRACCAR_EMAIL_PARAM.value();
    const password = TRACCAR_PASSWORD_PARAM.value();

    if (!email || !password) {
        throw new Error('Missing TRACCAR_EMAIL or TRACCAR_PASSWORD env variables.');
    }

    const formData = new URLSearchParams();
    formData.append('email', email);
    formData.append('password', password);

    try {
        const traccarResponse = await axios.post(
            `${TRACCAR_BASE_URL}/session`,
            formData.toString(), // Axios sends URLSearchParams as application/x-www-form-urlencoded
            {
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                validateStatus: () => true,
            }
        );

        const setCookie = traccarResponse.headers['set-cookie'];
        
        if (traccarResponse.status !== 200 || !setCookie || setCookie.length === 0) {
            console.error('Traccar login failed:', traccarResponse.status, traccarResponse.data);
            throw new Error('Failed to establish Traccar admin session.');
        }

        // Extract the JSESSIONID cookie
        const sessionCookie = setCookie.find(c => c.startsWith('JSESSIONID=')) || setCookie[0];
        
        // Update the global state
        traccarSessionCookie = sessionCookie.split(';')[0]; // Store only JSESSIONID=...
        lastLoginAttempt = now;
        console.log('Traccar session established successfully.');
        return traccarSessionCookie;

    } catch (e) {
        console.error('Traccar session attempt error:', e.message);
        // Clear session state on failure
        traccarSessionCookie = null;
        lastLoginAttempt = 0;
        throw new Error('Internal service error: Could not connect to Traccar.');
    }
};


// Router mounted at /api/v1
const router = express.Router();

// Apply Firebase Auth middleware to all API routes
router.use(authenticateFirebaseUser);

/**
 * GET /api/v1/positions
 * Fetches the latest positions for all devices accessible by the admin user.
 * The client MUST include a Firebase ID Token in the Authorization header.
 * * TODO: In the final implementation, we would modify the query to only fetch positions
 * for the devices linked to the authenticated user (req.user.uid).
 */
router.get('/positions', async (req, res) => {
    // Firebase user is authenticated (from middleware), now ensure Traccar session
    let sessionCookie;
    try {
        sessionCookie = await ensureTraccarSession();
    } catch (err) {
        return res.status(503).json({ error: err.message || 'Service Unavailable' });
    }

    try {
        const positionsResponse = await axios.get(
            `${TRACCAR_BASE_URL}/positions`,
            {
                headers: {
                    'Cookie': sessionCookie, // Use the ADMIN session cookie
                    'Accept': 'application/json',
                },
                validateStatus: () => true, // Don't throw on non-200 status
            }
        );

        if (positionsResponse.status === 401 || positionsResponse.status === 403) {
            // If the admin session expires, force a re-login on the next attempt
            traccarSessionCookie = null;
            return res.status(401).json({ error: 'Traccar session expired, please retry login.' });
        }

        if (positionsResponse.status !== 200) {
            return res.status(positionsResponse.status).json({
                error: 'Failed to fetch positions from Traccar',
                status: positionsResponse.status,
            });
        }

        // Successful response
        return res.status(200).json(positionsResponse.data);

    } catch (err) {
        console.error('Positions proxy error:', err.message);
        return res.status(500).json({ error: 'Internal error during positions fetch' });
    }
});

// Mount router
app.use('/api/v1', router);

// Export Cloud Function entry point
exports.api = functions.https.onRequest(app);