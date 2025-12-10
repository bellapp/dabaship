const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const auth = admin.auth();
const db = admin.firestore();

async function createRiderAccount() {
  try {
    const phone = '0612345678';
    const password = '123456';
    const email = `${phone}@daba.app`;
    const name = 'Test Rider';

    console.log('Creating rider account...');
    console.log(`Email: ${email}`);
    console.log(`Password: ${password}`);

    // Create user in Firebase Auth
    let user;
    try {
      user = await auth.createUser({
        email: email,
        password: password,
        displayName: name,
      });
      console.log('✅ User created in Firebase Auth');
    } catch (error) {
      if (error.code === 'auth/email-already-exists') {
        console.log('⚠️  User already exists, getting existing user...');
        user = await auth.getUserByEmail(email);
      } else {
        throw error;
      }
    }

    // Create rider profile in Firestore
    await db.collection('riders').doc(user.uid).set({
      name: name,
      phone: phone,
      email: email,
      isAvailable: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log('✅ Rider profile created in Firestore');
    console.log('\n📱 Rider Account Details:');
    console.log(`   Phone: ${phone}`);
    console.log(`   Password: ${password}`);
    console.log(`   UID: ${user.uid}`);
    console.log('\n✅ You can now login to the rider app!');

  } catch (error) {
    console.error('❌ Error creating rider account:', error);
  }
}

createRiderAccount();
