import 'package:flutter/foundation.dart';

class AppStrings {
  static final ValueNotifier<String> currentLocale = ValueNotifier<String>('en');

  static bool get isThai => currentLocale.value == 'th';

  static String tr({required String en, required String th}) => isThai ? th : en;

  // Common Navigation & Tabs
  static String get home => tr(en: 'Home', th: 'หน้าหลัก');
  static String get journey => tr(en: 'Journey', th: 'การเดินทาง');
  static String get daily => tr(en: 'Daily', th: 'ประจำวัน');
  static String get collection => tr(en: 'Collection', th: 'ของสะสม');
  static String get profile => tr(en: 'Profile', th: 'โปรไฟล์');
  static String get leaderboard => tr(en: 'Leaderboard', th: 'อันดับผู้นำ');
  static String get settings => tr(en: 'Settings', th: 'ตั้งค่า');

  // First Launch / Auth / Welcome
  static String get appTitle => 'Critter Camp';
  static String get appTagline => tr(en: 'Find a home for every critter.', th: 'หาบ้านที่แสนอบอุ่นให้น้องสัตว์ทุกตัว');
  static String get playAsGuest => tr(en: '🏕️ Play as Guest', th: '🏕️ เล่นแบบผู้เยี่ยมชม');
  static String get signInOrRegister => tr(en: '🔑 Sign In / Register', th: '🔑 เข้าสู่ระบบ / สมัครสมาชิก');
  static String get howToPlay => tr(en: '📖 How to Play', th: '📖 วิธีการเล่น');
  static String get offlineFriendly => tr(en: 'No timer pressure • Offline friendly', th: 'เล่นออฟไลน์ได้ • ไม่จำกัดเวลา');
  static String get cancel => tr(en: 'Cancel', th: 'ยกเลิก');
  static String get continueBtn => tr(en: 'Continue', th: 'ดำเนินการต่อ');
  static String get emailLabel => tr(en: 'Email Address', th: 'อีเมล');
  static String get camperNameLabel => tr(en: 'Camper Name', th: 'ชื่อผู้เล่น (Camper Name)');
  static String get countryLabel => tr(en: 'Country (for Leaderboard)', th: 'ประเทศ (สำหรับ Leaderboard)');
  static String get welcomePortal => tr(en: 'Welcome & Account Portal', th: 'หน้าต้อนรับ & บัญชีผู้เล่น');
  static String get welcomePortalSub => tr(en: 'Switch Account • Play as Guest • Register', th: 'สลับบัญชี • เล่นเป็น Guest • สมัครสมาชิก');

  // Home Hub
  static String get readyForBrainBreak => tr(en: 'Ready for a little\nbrain break?', th: 'พร้อมฝึกสมองเบาๆ\nหรือยัง?');
  static String get stageWaiting => tr(en: 'is waiting for you.', th: 'กำลังรอน้องๆ เข้าพัก');
  static String get playCurrentStage => tr(en: 'Play Stage', th: 'เล่นด่าน');
  static String get dailyChallenge => tr(en: 'Daily Puzzle', th: 'ปริศนาประจำวัน');
  static String get playDaily => tr(en: 'Play Daily', th: 'เล่นประจำวัน');
  static String get recentCritters => tr(en: 'Recent Critters', th: 'สัตว์ที่ปลดล็อกล่าสุด');
  static String get viewLeaderboard => tr(en: 'Camp Leaderboard', th: 'ดูกระดานผู้นำ');
  static String get topCampersThisWeek => tr(en: 'View Weekly & Thailand Rankings', th: 'ดูอันดับผู้เล่นสัปดาห์นี้');
  static String get unlocked => tr(en: 'Unlocked', th: 'ปลดล็อกแล้ว');

  // Journey
  static String get biomes => tr(en: 'Forest & Meadow Trail', th: 'เส้นทางป่าและทุ่งหญ้า');
  static String get stagePrefix => tr(en: 'Stage', th: 'ด่านที่');
  static String get stagesCleared => tr(en: 'Stages Cleared', th: 'ด่านที่ผ่านแล้ว');
  static String get currentLevelBadge => tr(en: 'Current Level', th: 'ด่านปัจจุบัน');
  static String get stars => tr(en: 'Stars', th: 'ดาว');

  // Gameplay
  static String get back => tr(en: 'Back', th: 'ย้อนกลับ');
  static String get restart => tr(en: 'Restart', th: 'เริ่มใหม่');
  static String get undo => tr(en: 'Undo', th: 'เลิกทำ');
  static String get hint => tr(en: 'Hint', th: 'คำใบ้');
  static String get placeCritterTool => tr(en: 'Place', th: 'วางสัตว์');
  static String get markXTool => tr(en: 'Mark X', th: 'กา X');
  static String get moves => tr(en: 'Moves', th: 'จำนวนตา');
  static String get time => tr(en: 'Time', th: 'เวลา');
  static String get lives => tr(en: 'Lives', th: 'หัวใจ');
  static String get rulesHint => tr(en: '1 critter per row/col/region • No touching!', th: '1 ตัวต่อแถว/หลัก/โซน • ห้ามแตะโดนกัน');

  // Level Complete
  static String get levelCompleteTitle => tr(en: 'Level Complete!', th: 'ยอดเยี่ยมมาก!');
  static String get levelCompleteSub => tr(en: 'Every critter found a cozy home.', th: 'น้องสัตว์ทุกตัวได้บ้านที่อบอุ่นแล้ว');
  static String get nextStage => tr(en: 'Next Stage', th: 'ด่านถัดไป');
  static String get replayStage => tr(en: 'Replay', th: 'เล่นซ้ำ');
  static String get backToCamp => tr(en: 'Back to Camp', th: 'กลับหน้าหลัก');
  static String get doubleAcorns => tr(en: 'Double Acorns (Watch Video)', th: 'รับลูกโอ๊ก x2 (ดูวิดีโอ)');

  // Daily Challenge Screen
  static String get dailyChallengeTitle => tr(en: 'Daily Camp Puzzle', th: 'ปริศนาแคมป์ประจำวัน');
  static String get dailyChallengeSub => tr(en: 'A fresh cozy puzzle every 24 hours. Solve to earn bonus Acorns and maintain your daily streak!', th: 'ปริศนาใหม่ทุกวัน แก้เพื่อรับลูกโอ๊กโบนัสและรักษาสถิติเล่นต่อเนื่อง!');
  static String get playDailyChallenge => tr(en: 'Play Daily Challenge', th: 'เล่นปริศนาประจำวัน');
  static String get rewardAcorns => tr(en: '+25 Acorns', th: '+25 ลูกโอ๊ก');
  static String get dailyStreak => tr(en: 'Daily Streak', th: 'สถิติเล่นต่อเนื่อง');

  // Collection Screen
  static String get campCrittersTitle => tr(en: 'Camp Critters Collection', th: 'สมุดสะสมสัตว์ในแคมป์');
  static String get habitatBiomes => tr(en: 'Habitats & Biomes', th: 'ถิ่นที่อยู่อาศัย & โซนป่า');
  static String get lockedCritter => tr(en: 'Locked Critter', th: 'สัตว์ยังไม่ปลดล็อก');
  static String get unlockAtLevel => tr(en: 'Unlocked by clearing stages', th: 'ปลดล็อกได้จากการผ่านด่าน');

  // Profile Screen
  static String get camperLevel => tr(en: 'Camper Level', th: 'เลเวลผู้ดูแลแคมป์');
  static String get currentStreak => tr(en: 'Streak Days', th: 'จำนวนวันต่อเนื่อง');
  static String get totalAcorns => tr(en: 'Total Acorns', th: 'ลูกโอ๊กทั้งหมด');
  static String get badgesAndAchievements => tr(en: 'Badges & Achievements', th: 'เหรียญตรา & ความสำเร็จ');
  static String get cloudSyncStatus => tr(en: 'Cloud Sync Status', th: 'สถานะซิงก์ข้อมูล Cloud');
  static String get syncNow => tr(en: 'Sync Now', th: 'ซิงก์ข้อมูลตอนนี้');
  static String get syncCompleted => tr(en: 'Cloud sync completed!', th: 'ซิงก์ข้อมูล Cloud สำเร็จแล้ว!');
  static String get guestMode => tr(en: 'Guest Camper', th: 'ผู้เยี่ยมชม (Guest)');
  static String get connectedAccount => tr(en: 'Connected Account', th: 'เชื่อมต่อบัญชีแล้ว');

  // Leaderboard Screen
  static String get topCampers => tr(en: 'Camp Leaderboard', th: 'กระดานผู้นำแคมป์');
  static String get globalTab => tr(en: '🌍 Global', th: '🌍 ทั่วโลก');
  static String get thailandTab => tr(en: '🇹🇭 Thailand', th: '🇹🇭 ประเทศไทย');
  static String get weeklyTab => tr(en: 'Weekly', th: 'ประจำสัปดาห์');
  static String get dailyTab => tr(en: 'Daily', th: 'ประจำวัน');
  static String get rankHeader => tr(en: 'Rank', th: 'อันดับ');
  static String get camperHeader => tr(en: 'Camper', th: 'ผู้เล่น');
  static String get scoreHeader => tr(en: 'Score', th: 'คะแนน');

  // Tutorial / How to Play
  static String get howToPlayTitle => tr(en: 'How to Play Critter Camp', th: 'วิธีเล่น Critter Camp');
  static String get rule1Title => tr(en: '1. One Critter Per Row & Col', th: '1. ตัวละคร 1 ตัวต่อแถวและหลัก');
  static String get rule1Desc => tr(en: 'Each horizontal row and vertical column must contain exactly one critter.', th: 'ในแต่ละแถวแนวนอนและแนวตั้ง จะต้องมีสัตว์อยู่ได้แค่ช่องเดียวเท่านั้น');
  static String get rule2Title => tr(en: '2. One Critter Per Colored Region', th: '2. ตัวละคร 1 ตัวต่อโซนสี');
  static String get rule2Desc => tr(en: 'Each colored habitat zone must contain exactly one critter.', th: 'ในแต่ละโซนสีของป่า จะต้องมีสัตว์อยู่ได้แค่ตัวเดียวเท่านั้น');
  static String get rule3Title => tr(en: '3. No Touching (Even Diagonally!)', th: '3. ห้ามแตะโดนกัน (รวมถึงแนวทแยง!)');
  static String get rule3Desc => tr(en: 'Critters cannot touch each other in any of the 8 surrounding neighbor cells.', th: 'สัตว์ทุกตัวห้ามอยู่ติดกันทั้ง 8 ทิศรอบตัว รวมถึงมุมทแยงมุม');
  static String get gotIt => tr(en: 'Got it, Let\'s Play!', th: 'เข้าใจแล้ว ไปเล่นกันเลย!');

  // Settings
  static String get languageSetting => tr(en: 'Language / ภาษา', th: 'ภาษา / Language');
  static String get gameplayComfort => tr(en: 'Gameplay & Comfort', th: 'การเล่นและความสบายตา');
  static String get zenMode => tr(en: 'Zen Mode (Unlimited Lives)', th: 'โหมดผ่อนคลาย (ไม่จำกัดหัวใจ)');
  static String get zenModeSub => tr(en: 'Relax without losing hearts on mistakes', th: 'เล่นสบายๆ ไม่หักหัวใจเมื่อวางผิด');
  static String get highContrast => tr(en: 'Pattern / High Contrast Mode', th: 'โหมดลวดลายความเปรียบต่างสูง');
  static String get highContrastSub => tr(en: 'Add shapes to colored regions for accessibility', th: 'เพิ่มลวดลายในแต่ละโซนเพื่อการมองเห็นที่ชัดเจน');
  static String get soundAndAtmosphere => tr(en: 'Sound & Atmosphere', th: 'ระบบเสียงและบรรยากาศ');
  static String get campfireMusic => tr(en: 'Campfire Music', th: 'ดนตรีรอบกองไฟ (BGM)');
  static String get sfxVolume => tr(en: 'Sound Effects (SFX)', th: 'เสียงเอฟเฟกต์ (SFX)');
  static String get accountAndSync => tr(en: 'Account & Cloud Sync', th: 'บัญชีและการซิงก์ข้อมูล');
  static String get openWelcomeScreen => tr(en: 'Open Welcome / Sign In Screen', th: 'เปิดหน้ายินดีต้อนรับ / เข้าสู่ระบบ');
  static String get openWelcomeScreenSub => tr(en: 'Revisit first launch screen to switch accounts', th: 'เปิดหน้าแรกเพื่อสลับบัญชีหรือสมัครใหม่');
}
