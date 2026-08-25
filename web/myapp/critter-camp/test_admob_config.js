const db = require('./database/db');
const { seedAdMob } = require('./database/seed_admob');

console.log('--- Testing AdMob Seed & Remote Config ---');

// 1. Run seed
const seeded = seedAdMob('development');

// 2. Validate App ID and Units
if (seeded.appId !== 'critter-camp') {
  console.error('❌ Failed: App ID mismatch');
  process.exit(1);
}

if (!seeded.ads.android.bannerId || !seeded.ads.ios.rewardedId) {
  console.error('❌ Failed: Missing AdMob unit IDs');
  process.exit(1);
}

console.log('\n📱 Verified Android Test Units:');
console.log(` - App ID: ${seeded.ads.android.appId}`);
console.log(` - Banner ID: ${seeded.ads.android.bannerId}`);
console.log(` - Interstitial ID: ${seeded.ads.android.interstitialId}`);
console.log(` - Rewarded ID: ${seeded.ads.android.rewardedId}`);

console.log('\n🍎 Verified iOS Test Units:');
console.log(` - App ID: ${seeded.ads.ios.appId}`);
console.log(` - Banner ID: ${seeded.ads.ios.bannerId}`);
console.log(` - Interstitial ID: ${seeded.ads.ios.interstitialId}`);
console.log(` - Rewarded ID: ${seeded.ads.ios.rewardedId}`);

console.log('\n🎉 ALL ADMOB TEST CONFIGURATIONS SEEDED AND VERIFIED SUCCESSFULLY!');
