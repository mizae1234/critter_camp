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

  // First Launch / Auth
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

  // Home Hub
  static String get readyForBrainBreak => tr(en: 'Ready for a little brain break?', th: 'พร้อมฝึกสมองเบาๆ หรือยัง?');
  static String get stageWaiting => tr(en: 'is waiting for you.', th: 'กำลังรอน้องๆ เข้าพัก');
  static String get playCurrentStage => tr(en: 'Play Stage', th: 'เล่นด่าน');
  static String get dailyChallenge => tr(en: 'Daily Puzzle', th: 'ปริศนาประจำวัน');
  static String get playDaily => tr(en: 'Play Daily', th: 'เล่นประจำวัน');
  static String get recentCritters => tr(en: 'Recent Critters', th: 'สัตว์ที่ปลดล็อกล่าสุด');
  static String get viewLeaderboard => tr(en: 'Camp Leaderboard', th: 'ดูกระดานผู้นำ');
  static String get topCampersThisWeek => tr(en: 'View Weekly & Thailand Rankings', th: 'ดูอันดับผู้เล่นสัปดาห์นี้');

  // Journey
  static String get biomes => tr(en: 'Biomes & Trails', th: 'แผนที่การเดินทาง');
  static String get stagePrefix => tr(en: 'Stage', th: 'ด่านที่');
  static String get locked => tr(en: 'Locked', th: 'ยังไม่ปลดล็อก');

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
}
