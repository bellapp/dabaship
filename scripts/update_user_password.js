const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const auth = admin.auth();

async function updateUserPassword() {
  try {
    const phone = '0672591619';
    const newPassword = '123456';
    const email = `${phone}@daba.app`;

    console.log('Updating user password...');
    console.log(`Email: ${email}`);
    console.log(`New Password: ${newPassword}`);

    // Get user by email
    const user = await auth.getUserByEmail(email);
    
    // Update password
    await auth.updateUser(user.uid, {
      password: newPassword,
    });

    console.log('✅ Password updated successfully!');
    console.log('\n📱 Updated Account Details:');
    console.log(`   Phone: ${phone}`);
    console.log(`   Password: ${newPassword}`);
    console.log(`   UID: ${user.uid}`);
    console.log('\n✅ You can now login with the new password!');

  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      console.log('❌ User not found. Creating new user...');
      
      const phone = '0672591619';
      const password = '123456';
      const email = `${phone}@daba.app`;
      const name = 'Test User';

      const user = await auth.createUser({
        email: email,
        password: password,
        displayName: name,
      });

      console.log('✅ New user created!');
      console.log(`   Phone: ${phone}`);
      console.log(`   Password: ${password}`);
      console.log(`   UID: ${user.uid}`);
    } else {
      console.error('❌ Error:', error);
    }
  }
}

updateUserPassword();
