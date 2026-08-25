import 'package:flutter/foundation.dart';

class AppStrings {
  static final ValueNotifier<String> currentLocale = ValueNotifier<String>('th');

  static bool get isThai => currentLocale.value == 'th';

  // Common Navigation & Titles
  static String get home => isThai ? 'หน้าหลัก' : 'Home';
  static String get journey => isThai ? 'การเดินทาง' : 'Journey';
  static String get daily => isThai ? 'ประจำวัน' : 'Daily';
  static String get collection => isThai ? 'ของสะสม' : 'Collection';
  static String get profile => isThai ? 'โปรไฟล์' : 'Profile';
  static String get leaderboard => isThai ? 'อันดับผู้นำ' : 'Leaderboard';
  static String get settings => isThai ? 'ตั้งค่า' : 'Settings';

  // First Launch / Auth
  static String get appTitle => 'Critter Camp';
  static String get appTagline => isThai ? 'หาบ้านที่แสนอบอุ่นให้น้องสัตว์ทุกตัว' : 'Find a home for every critter.';
  static String get playAsGuest => isThai ? '🏕️ เล่นแบบผู้เยี่ยมชม (Guest)' : '🏕️ Play as Guest';
  static String get signInOrRegister => isThai ? '🔑 เข้าสู่ระบบ / สมัครสมาชิก' : '🔑 Sign In / Register';
  static String get howToPlay => isThai ? '📖 วิธีการเล่น' : '📖 How to Play';
  static String get offlineFriendly => isThai ? 'เล่นออฟไลน์ได้ • ไม่จำกัดเวลา' : 'No timer pressure • Offline friendly';

  // Home Hub
  static String get readyForBrainBreak => isThai ? 'พร้อมฝึกสมองเบาๆ หรือยัง?' : 'Ready for a little brain break?';
  static String get stageWaiting => isThai ? 'กำลังรอน้องๆ เข้าพัก' : 'is waiting for you.';
  static String get playCurrentStage => isThai ? 'เล่นด่าน' : 'Play Stage';
  static String get dailyChallenge => isThai ? 'ปริศนาประจำวัน' : 'Daily Puzzle';
  static String get playDaily => isThai ? 'เล่นประจำวัน' : 'Play Daily';
  static String get recentCritters => isThai ? 'สัตว์ที่ปลดล็อกล่าสุด' : 'Recent Critters';
  static String get viewLeaderboard => isThai ? 'ดูกระดานผู้นำ' : 'View Leaderboard';
  static String get topCampersThisWeek => isThai ? 'ดูอันดับผู้เล่นสัปดาห์นี้' : 'Top campers ranking this week';

  // Gameplay
  static String get back => isThai ? 'ย้อนกลับ' : 'Back';
  static String get restart => isThai ? 'เริ่มใหม่' : 'Restart';
  static String get undo => isThai ? 'เลิกทำ' : 'Undo';
  static String get hint => isThai ? 'คำใบ้' : 'Hint';
  static String get placeCritterTool => isThai ? 'วางสัตว์' : 'Place';
  static String get markXTool => isThai ? 'กา X' : 'Mark X';

  // Level Complete
  static String get levelCompleteTitle => isThai ? 'ยอดเยี่ยมมาก!' : 'Level Complete!';
  static String get levelCompleteSub => isThai ? 'น้องสัตว์ทุกตัวได้บ้านที่อบอุ่นแล้ว' : 'Every critter found a cozy home.';
  static String get nextStage => isThai ? 'ด่านถัดไป' : 'Next Stage';
  static String get replayStage => isThai ? 'เล่นซ้ำ' : 'Replay';
  static String get backToCamp => isThai ? 'กลับหน้าหลัก' : 'Back to Camp';
  static String get doubleAcorns => isThai ? 'รับลูกโอ๊ก x2 (ดูวิดีโอ)' : 'Double Acorns (Watch Video)';
}
