/**
 * AdMob Test & Production Configuration Seeder
 * Part of Critter Camp Shared Web Admin Integration
 */

const db = require('./db');

const ADMOB_SEEDS = {
  // 1. Google Official Sample / Test AdMob IDs (Safe for Development & QA)
  development: {
    appId: 'critter-camp',
    appName: 'Critter Camp (Dev/Test)',
    environment: 'development',
    adsEnabled: true,
    ads: {
      android: {
        appId: 'ca-app-pub-3940256099942544~3347511713',
        bannerId: 'ca-app-pub-3940256099942544/6300978111',
        interstitialId: 'ca-app-pub-3940256099942544/1033173712',
        rewardedId: 'ca-app-pub-3940256099942544/5224354917',
        rewardedInterstitialId: 'ca-app-pub-3940256099942544/5354046379',
        nativeAdvancedId: 'ca-app-pub-3940256099942544/2247696110',
      },
      ios: {
        appId: 'ca-app-pub-3940256099942544~1458002511',
        bannerId: 'ca-app-pub-3940256099942544/2934735716',
        interstitialId: 'ca-app-pub-3940256099942544/4411468910',
        rewardedId: 'ca-app-pub-3940256099942544/1712485313',
        rewardedInterstitialId: 'ca-app-pub-3940256099942544/6978759866',
        nativeAdvancedId: 'ca-app-pub-3940256099942544/3986624511',
      },
    },
    monetization: {
      enabled: true,
      rewarded: {
        enabled: true,
        hintEnabled: true,
        postStageBonusEnabled: true,
      },
      interstitial: {
        enabled: true,
        stageInterval: 3,
        cooldownSeconds: 180,
        minimumStageBeforeFirstAd: 4,
        rewardedGracePeriodSeconds: 90,
      },
      hints: {
        firstHintFree: true,
        maxHintsPerStage: 3,
      },
    },
    placements: {
      homeBanner: {
        enabled: true,
        adFormat: 'adaptive_banner',
        position: 'bottom',
      },
      stageCompleteInterstitial: {
        enabled: true,
        frequency: 'every_3_stages',
      },
      hintRewarded: {
        enabled: true,
        rewardAcorns: 10,
        rewardHints: 1,
      },
    },
    featureFlags: {
      zenModeEnabled: true,
      patternModeEnabled: true,
      cloudSyncEnabled: true,
      progressiveHintsEnabled: true,
    },
    maintenanceMode: false,
    minVersion: '1.0.0',
    seededAt: new Date().toISOString(),
  },

  // 2. Production Config Template
  production: {
    appId: 'critter-camp',
    appName: 'Critter Camp (Production)',
    environment: 'production',
    adsEnabled: true,
    ads: {
      android: {
        appId: 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX',
        bannerId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
        interstitialId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
        rewardedId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
      },
      ios: {
        appId: 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX',
        bannerId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
        interstitialId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
        rewardedId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
      },
    },
    monetization: {
      enabled: true,
      rewarded: {
        enabled: true,
        hintEnabled: true,
        postStageBonusEnabled: true,
      },
      interstitial: {
        enabled: true,
        stageInterval: 3,
        cooldownSeconds: 180,
        minimumStageBeforeFirstAd: 4,
        rewardedGracePeriodSeconds: 90,
      },
      hints: {
        firstHintFree: true,
        maxHintsPerStage: 3,
      },
    },
    maintenanceMode: false,
    minVersion: '1.0.0',
    seededAt: new Date().toISOString(),
  },
};

function seedAdMob(env = 'development') {
  const seedData = ADMOB_SEEDS[env] || ADMOB_SEEDS.development;
  const result = db.updateAppConfig('critter-camp', seedData);
  console.log(`\n✅ [AdMob Seeder] Successfully seeded AdMob test configuration for [${env.toUpperCase()}]!`);
  return result;
}

if (require.main === module) {
  seedAdMob('development');
}

module.exports = { seedAdMob, ADMOB_SEEDS };
