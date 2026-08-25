import '../stage_definition.dart';
import '../../bonus/no_hints_bonus.dart';
import '../../bonus/move_efficiency_bonus.dart';

/// Complete Handcrafted & Verified 30-Stage Adventure Catalog.
/// Spans 6 Chapters/Biomes with rich story lore, progressive difficulty (4x4 to 8x8),
/// and guaranteed mathematical solvability.
class StageCatalog {
  /// Stage 1: Sunlit Meadow (Chapter 1: Whispering Meadow - 4x4, 2 solution(s))
  static const StageDefinition stage1 = StageDefinition(
    id: 'stage-001',
    stageNumber: 1,
    name: 'Sunlit Meadow',
    biomeName: 'Camp Entrance',
    size: 4,
    chapterNumber: 1,
    chapterName: 'Whispering Meadow',
    storySpeaker: 'Hazel',
    speakerEmoji: '🦊',
    storyTextEn: 'Welcome to camp! Let\'s place 1 critter in each habitat.',
    storyTextTh: 'ยินดีต้อนรับสู่แคมป์! วันนี้แดดอุ่นมาก มาช่วยจัดที่พักให้เพื่อนๆ กัน',
    rewardCritterId: 'hazel',
    baseAcornsReward: 10,
    description: 'Welcome to camp! Let\'s place 1 critter in each habitat.',
    habitatGrid: [
      [2, 0, 1, 1],
      [2, 0, 1, 1],
      [2, 0, 3, 3],
      [2, 0, 3, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 6),
    ],
  );

  /// Stage 2: Picnic Patch (Chapter 1: Whispering Meadow - 4x4, 1 solution(s))
  static const StageDefinition stage2 = StageDefinition(
    id: 'stage-002',
    stageNumber: 2,
    name: 'Picnic Patch',
    biomeName: 'Camp Entrance',
    size: 4,
    chapterNumber: 1,
    chapterName: 'Whispering Meadow',
    storySpeaker: 'Hazel',
    speakerEmoji: '🦊',
    storyTextEn: 'Let\'s lay down the picnic mat under the shady oak tree.',
    storyTextTh: 'มาปูเสื่อปิกนิกใต้ร่มไม้ใหญ่ แล้ววางเสบียงให้เรียบร้อยนะ',
    rewardCritterId: 'hazel',
    baseAcornsReward: 10,
    description: 'Let\'s lay down the picnic mat under the shady oak tree.',
    habitatGrid: [
      [1, 1, 0, 0],
      [1, 1, 1, 0],
      [3, 3, 3, 2],
      [3, 3, 3, 2],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 6),
    ],
  );

  /// Stage 3: Acorn Clearing (Chapter 1: Whispering Meadow - 5x5, 7 solution(s))
  static const StageDefinition stage3 = StageDefinition(
    id: 'stage-003',
    stageNumber: 3,
    name: 'Acorn Clearing',
    biomeName: 'Camp Entrance',
    size: 5,
    chapterNumber: 1,
    chapterName: 'Whispering Meadow',
    storySpeaker: 'Hazel',
    speakerEmoji: '🦊',
    storyTextEn: 'Gathering golden acorns around the cozy clearing.',
    storyTextTh: 'เดินเก็บลูกโอ๊กสีทองรอบลานหญ้า ระวังอย่าเหยียบกิ่งไม้นะ',
    rewardCritterId: 'hazel',
    baseAcornsReward: 15,
    description: 'Gathering golden acorns around the cozy clearing.',
    habitatGrid: [
      [0, 1, 1, 1, 2],
      [0, 0, 1, 1, 2],
      [0, 0, 2, 2, 2],
      [3, 3, 3, 4, 4],
      [3, 3, 3, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 8),
    ],
  );

  /// Stage 4: Firefly Nook (Chapter 1: Whispering Meadow - 5x5, 4 solution(s))
  static const StageDefinition stage4 = StageDefinition(
    id: 'stage-004',
    stageNumber: 4,
    name: 'Firefly Nook',
    biomeName: 'Camp Entrance',
    size: 5,
    chapterNumber: 1,
    chapterName: 'Whispering Meadow',
    storySpeaker: 'Hazel',
    speakerEmoji: '🦊',
    storyTextEn: 'Tiny fireflies are waking up as the evening breeze blows.',
    storyTextTh: 'หิ่งห้อยตัวน้อยเริ่มเปล่งแสงวิบวับในยามเย็น',
    rewardCritterId: 'hazel',
    baseAcornsReward: 15,
    description: 'Tiny fireflies are waking up as the evening breeze blows.',
    habitatGrid: [
      [1, 0, 0, 0, 0],
      [1, 1, 2, 2, 0],
      [1, 1, 2, 2, 4],
      [3, 3, 3, 2, 4],
      [3, 3, 4, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 8),
    ],
  );

  /// Stage 5: Campfire Circle (Chapter 1: Whispering Meadow - 5x5, 3 solution(s))
  static const StageDefinition stage5 = StageDefinition(
    id: 'stage-005',
    stageNumber: 5,
    name: 'Campfire Circle',
    biomeName: 'Camp Entrance',
    size: 5,
    chapterNumber: 1,
    chapterName: 'Whispering Meadow',
    storySpeaker: 'Hazel',
    speakerEmoji: '🦊',
    storyTextEn: 'The warm campfire is glowing! We completed our first camp!',
    storyTextTh: 'กองไฟอุ่นๆ จุดสว่างแล้ว! แคมป์แรกของเราพร้อมต้อนรับทุกคน',
    rewardCritterId: 'hazel',
    baseAcornsReward: 20,
    description: 'The warm campfire is glowing! We completed our first camp!',
    habitatGrid: [
      [0, 0, 0, 0, 2],
      [1, 1, 0, 0, 2],
      [1, 1, 2, 2, 2],
      [3, 3, 2, 2, 4],
      [3, 3, 3, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 9),
    ],
  );

  /// Stage 6: Whispering Pines (Chapter 2: Pine Haven Trail - 5x5, 5 solution(s))
  static const StageDefinition stage6 = StageDefinition(
    id: 'stage-006',
    stageNumber: 6,
    name: 'Whispering Pines',
    biomeName: 'Pine Forest',
    size: 5,
    chapterNumber: 2,
    chapterName: 'Pine Haven Trail',
    storySpeaker: 'Finn',
    speakerEmoji: '🐿️',
    storyTextEn: 'Tall pine trees rustle gently in the morning mist.',
    storyTextTh: 'ต้นสนสูงตระหง่านส่งเสียงกระซิบในสายหมอกยามเช้า',
    rewardCritterId: 'finn',
    baseAcornsReward: 15,
    description: 'Tall pine trees rustle gently in the morning mist.',
    habitatGrid: [
      [0, 0, 0, 0, 1],
      [0, 1, 1, 1, 1],
      [0, 3, 2, 2, 2],
      [3, 3, 4, 4, 2],
      [3, 3, 4, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 9),
    ],
  );

  /// Stage 7: Needle Path (Chapter 2: Pine Haven Trail - 5x5, 8 solution(s))
  static const StageDefinition stage7 = StageDefinition(
    id: 'stage-007',
    stageNumber: 7,
    name: 'Needle Path',
    biomeName: 'Pine Forest',
    size: 5,
    chapterNumber: 2,
    chapterName: 'Pine Haven Trail',
    storySpeaker: 'Finn',
    speakerEmoji: '🐿️',
    storyTextEn: 'Step softly on the soft carpet of crunchy pine needles.',
    storyTextTh: 'ก้าวเบาๆ บนพรมใบสนสีน้ำตาล ทางเริ่มคดเคี้ยวแล้วนะ',
    rewardCritterId: 'finn',
    baseAcornsReward: 15,
    description: 'Step softly on the soft carpet of crunchy pine needles.',
    habitatGrid: [
      [0, 0, 0, 1, 1],
      [0, 1, 1, 1, 1],
      [2, 2, 2, 2, 2],
      [3, 3, 3, 4, 4],
      [3, 3, 3, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 9),
    ],
  );

  /// Stage 8: Mossy Boulder (Chapter 2: Pine Haven Trail - 6x6, 30 solution(s))
  static const StageDefinition stage8 = StageDefinition(
    id: 'stage-008',
    stageNumber: 8,
    name: 'Mossy Boulder',
    biomeName: 'Pine Forest',
    size: 6,
    chapterNumber: 2,
    chapterName: 'Pine Haven Trail',
    storySpeaker: 'Finn',
    speakerEmoji: '🐿️',
    storyTextEn: 'A giant boulder covered in soft emerald forest moss.',
    storyTextTh: 'โขดหินยักษ์ที่ปกคลุมด้วยมอสเขียวชอุ่ม ให้ความเย็นสบาย',
    rewardCritterId: 'finn',
    baseAcornsReward: 20,
    description: 'A giant boulder covered in soft emerald forest moss.',
    habitatGrid: [
      [0, 0, 0, 0, 1, 1],
      [2, 0, 0, 1, 1, 3],
      [2, 2, 4, 1, 1, 3],
      [2, 2, 4, 3, 3, 3],
      [2, 4, 4, 4, 4, 3],
      [5, 5, 5, 5, 5, 5],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 9: Squirrel's Secret (Chapter 2: Pine Haven Trail - 6x6, 36 solution(s))
  static const StageDefinition stage9 = StageDefinition(
    id: 'stage-009',
    stageNumber: 9,
    name: 'Squirrel\'s Secret',
    biomeName: 'Pine Forest',
    size: 6,
    chapterNumber: 2,
    chapterName: 'Pine Haven Trail',
    storySpeaker: 'Finn',
    speakerEmoji: '🐿️',
    storyTextEn: 'Finn shows us where the sweetest pine nuts are hidden.',
    storyTextTh: 'เจ้ากระรอก Finn พามาดูคลังเก็บลูกสนลับแสนอร่อย',
    rewardCritterId: 'finn',
    baseAcornsReward: 20,
    description: 'Finn shows us where the sweetest pine nuts are hidden.',
    habitatGrid: [
      [2, 1, 1, 0, 0, 0],
      [2, 1, 1, 1, 0, 0],
      [2, 2, 1, 3, 3, 3],
      [2, 2, 5, 3, 3, 3],
      [5, 5, 5, 4, 4, 3],
      [5, 5, 4, 4, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 10: Canopy Lookout (Chapter 2: Pine Haven Trail - 6x6, 34 solution(s))
  static const StageDefinition stage10 = StageDefinition(
    id: 'stage-010',
    stageNumber: 10,
    name: 'Canopy Lookout',
    biomeName: 'Pine Forest',
    size: 6,
    chapterNumber: 2,
    chapterName: 'Pine Haven Trail',
    storySpeaker: 'Finn',
    speakerEmoji: '🐿️',
    storyTextEn: 'Climbing up high to view the entire emerald forest expanse.',
    storyTextTh: 'มองจากยอดไม้สน เห็นทัศนียภาพป่าเขียวขจีสุดลูกหูลูกตา',
    rewardCritterId: 'finn',
    baseAcornsReward: 25,
    description: 'Climbing up high to view the entire emerald forest expanse.',
    habitatGrid: [
      [0, 0, 0, 0, 0, 1],
      [2, 2, 1, 1, 1, 1],
      [2, 2, 2, 5, 1, 3],
      [2, 4, 5, 5, 3, 3],
      [4, 4, 4, 5, 3, 3],
      [4, 4, 4, 5, 5, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 11: Fragrant Slope (Chapter 3: Lavender Valley - 6x6, 31 solution(s))
  static const StageDefinition stage11 = StageDefinition(
    id: 'stage-011',
    stageNumber: 11,
    name: 'Fragrant Slope',
    biomeName: 'Purple Hollow',
    size: 6,
    chapterNumber: 3,
    chapterName: 'Lavender Valley',
    storySpeaker: 'Pip',
    speakerEmoji: '🦔',
    storyTextEn: 'Purple lavender blossoms wave gently in the warm breeze.',
    storyTextTh: 'เนินเขาสีม่วงของดอกลาเวนเดอร์ส่งกลิ่นหอมชื่นใจ',
    rewardCritterId: 'pip',
    baseAcornsReward: 20,
    description: 'Purple lavender blossoms wave gently in the warm breeze.',
    habitatGrid: [
      [2, 2, 1, 1, 1, 0],
      [2, 2, 1, 1, 1, 0],
      [2, 2, 5, 1, 0, 0],
      [4, 4, 5, 3, 3, 0],
      [4, 5, 5, 3, 3, 0],
      [4, 4, 5, 5, 3, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 12: Honeycomb Terrace (Chapter 3: Lavender Valley - 6x6, 15 solution(s))
  static const StageDefinition stage12 = StageDefinition(
    id: 'stage-012',
    stageNumber: 12,
    name: 'Honeycomb Terrace',
    biomeName: 'Purple Hollow',
    size: 6,
    chapterNumber: 3,
    chapterName: 'Lavender Valley',
    storySpeaker: 'Pip',
    speakerEmoji: '🦔',
    storyTextEn: 'Happy bees dancing between sweet nectar petals.',
    storyTextTh: 'ผึ้งน้อยบินร่ายรำเก็บน้ำหวานจากดอกไม้หลากสี',
    rewardCritterId: 'pip',
    baseAcornsReward: 20,
    description: 'Happy bees dancing between sweet nectar petals.',
    habitatGrid: [
      [1, 0, 0, 0, 0, 0],
      [1, 1, 2, 2, 0, 3],
      [1, 1, 2, 2, 0, 3],
      [5, 1, 1, 2, 3, 3],
      [5, 4, 4, 4, 4, 3],
      [5, 5, 4, 4, 4, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 13: Lavender Hollow (Chapter 3: Lavender Valley - 6x6, 23 solution(s))
  static const StageDefinition stage13 = StageDefinition(
    id: 'stage-013',
    stageNumber: 13,
    name: 'Lavender Hollow',
    biomeName: 'Purple Hollow',
    size: 6,
    chapterNumber: 3,
    chapterName: 'Lavender Valley',
    storySpeaker: 'Pip',
    speakerEmoji: '🦔',
    storyTextEn: 'Deep in the fragrant purple valley where peaceful naps await.',
    storyTextTh: 'หุบเขาดอกไม้แสนสงบ เหมาะแก่การพักผ่อนและจิบชา',
    rewardCritterId: 'pip',
    baseAcornsReward: 25,
    description: 'Deep in the fragrant purple valley where peaceful naps await.',
    habitatGrid: [
      [2, 2, 0, 0, 0, 0],
      [2, 2, 1, 1, 0, 0],
      [2, 2, 1, 1, 0, 3],
      [4, 4, 4, 1, 3, 3],
      [4, 4, 5, 1, 3, 3],
      [5, 5, 5, 5, 3, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 14: Herbal Meadow (Chapter 3: Lavender Valley - 6x6, 27 solution(s))
  static const StageDefinition stage14 = StageDefinition(
    id: 'stage-014',
    stageNumber: 14,
    name: 'Herbal Meadow',
    biomeName: 'Purple Hollow',
    size: 6,
    chapterNumber: 3,
    chapterName: 'Lavender Valley',
    storySpeaker: 'Pip',
    speakerEmoji: '🦔',
    storyTextEn: 'Pip is picking fresh chamomile and mint for evening tea.',
    storyTextTh: 'เม่นน้อย Pip ชวนเก็บใบคาโมมายล์และมินต์ไปต้มชารอบกองไฟ',
    rewardCritterId: 'pip',
    baseAcornsReward: 25,
    description: 'Pip is picking fresh chamomile and mint for evening tea.',
    habitatGrid: [
      [1, 1, 1, 0, 0, 0],
      [1, 1, 1, 0, 0, 0],
      [1, 3, 2, 2, 2, 4],
      [3, 3, 2, 2, 4, 4],
      [3, 3, 5, 2, 4, 4],
      [3, 5, 5, 5, 5, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 15: Sunset Blossom (Chapter 3: Lavender Valley - 6x6, 33 solution(s))
  static const StageDefinition stage15 = StageDefinition(
    id: 'stage-015',
    stageNumber: 15,
    name: 'Sunset Blossom',
    biomeName: 'Purple Hollow',
    size: 6,
    chapterNumber: 3,
    chapterName: 'Lavender Valley',
    storySpeaker: 'Pip',
    speakerEmoji: '🦔',
    storyTextEn: 'Golden sunset rays paint the purple slopes in amber light.',
    storyTextTh: 'แสงอาทิตย์อัสดงส่องประกายสีทองพาดผ่านทุ่งลาเวนเดอร์',
    rewardCritterId: 'pip',
    baseAcornsReward: 30,
    description: 'Golden sunset rays paint the purple slopes in amber light.',
    habitatGrid: [
      [2, 2, 0, 0, 1, 1],
      [2, 0, 0, 0, 1, 1],
      [2, 5, 3, 0, 1, 1],
      [2, 5, 3, 3, 4, 4],
      [2, 5, 3, 4, 4, 4],
      [5, 5, 3, 3, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 13),
    ],
  );

  /// Stage 16: Babbling Creek (Chapter 4: Willow Brook - 6x6, 29 solution(s))
  static const StageDefinition stage16 = StageDefinition(
    id: 'stage-016',
    stageNumber: 16,
    name: 'Babbling Creek',
    biomeName: 'Riverbank',
    size: 6,
    chapterNumber: 4,
    chapterName: 'Willow Brook',
    storySpeaker: 'River',
    speakerEmoji: '🦦',
    storyTextEn: 'Cool crystal water ripples over smooth pebbles.',
    storyTextTh: 'สายน้ำใสไหลเย็นเอื่อยๆ กระทบก้อนกรวดกลมเกลี้ยง',
    rewardCritterId: 'river',
    baseAcornsReward: 25,
    description: 'Cool crystal water ripples over smooth pebbles.',
    habitatGrid: [
      [0, 0, 0, 1, 2, 2],
      [0, 1, 1, 1, 2, 2],
      [0, 1, 1, 3, 2, 2],
      [4, 4, 3, 3, 3, 3],
      [4, 4, 5, 5, 5, 3],
      [4, 4, 5, 5, 5, 5],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
  );

  /// Stage 17: Stepping Stones (Chapter 4: Willow Brook - 6x6, 27 solution(s))
  static const StageDefinition stage17 = StageDefinition(
    id: 'stage-017',
    stageNumber: 17,
    name: 'Stepping Stones',
    biomeName: 'Riverbank',
    size: 6,
    chapterNumber: 4,
    chapterName: 'Willow Brook',
    storySpeaker: 'River',
    speakerEmoji: '🦦',
    storyTextEn: 'Hop carefully from one mossy river stone to the next!',
    storyTextTh: 'กระโดดข้ามหินริมน้ำอย่างระมัดระวัง อย่าลื่นตกน้ำนะ!',
    rewardCritterId: 'river',
    baseAcornsReward: 25,
    description: 'Hop carefully from one mossy river stone to the next!',
    habitatGrid: [
      [0, 0, 0, 1, 1, 1],
      [0, 2, 2, 1, 1, 1],
      [0, 2, 2, 2, 3, 3],
      [4, 2, 2, 5, 3, 3],
      [4, 4, 4, 5, 5, 3],
      [4, 4, 5, 5, 5, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 13),
    ],
  );

  /// Stage 18: Willow Shallows (Chapter 4: Willow Brook - 7x7, 73 solution(s))
  static const StageDefinition stage18 = StageDefinition(
    id: 'stage-018',
    stageNumber: 18,
    name: 'Willow Shallows',
    biomeName: 'Riverbank',
    size: 7,
    chapterNumber: 4,
    chapterName: 'Willow Brook',
    storySpeaker: 'River',
    speakerEmoji: '🦦',
    storyTextEn: 'Graceful willow branches dipping into the calm water.',
    storyTextTh: 'กิ่งหลิวห้อยระย้าสัมผัสผิวน้ำอันเงียบสงบ',
    rewardCritterId: 'river',
    baseAcornsReward: 30,
    description: 'Graceful willow branches dipping into the calm water.',
    habitatGrid: [
      [0, 0, 0, 0, 2, 2, 2],
      [4, 0, 1, 1, 1, 1, 2],
      [4, 0, 1, 3, 1, 1, 2],
      [4, 3, 3, 3, 6, 6, 2],
      [4, 4, 3, 3, 3, 6, 6],
      [4, 5, 5, 5, 5, 6, 6],
      [4, 5, 5, 5, 5, 6, 6],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 15),
    ],
  );

  /// Stage 19: Otter's Playground (Chapter 4: Willow Brook - 7x7, 91 solution(s))
  static const StageDefinition stage19 = StageDefinition(
    id: 'stage-019',
    stageNumber: 19,
    name: 'Otter\'s Playground',
    biomeName: 'Riverbank',
    size: 7,
    chapterNumber: 4,
    chapterName: 'Willow Brook',
    storySpeaker: 'River',
    speakerEmoji: '🦦',
    storyTextEn: 'River the otter loves sliding down the muddy riverbank!',
    storyTextTh: 'นากน้อย River ชวนลื่นไถลลงเนินดินเล่นน้ำอย่างสนุกสนาน',
    rewardCritterId: 'river',
    baseAcornsReward: 30,
    description: 'River the otter loves sliding down the muddy riverbank!',
    habitatGrid: [
      [2, 2, 0, 0, 0, 1, 1],
      [2, 2, 2, 0, 0, 1, 1],
      [5, 2, 2, 3, 3, 1, 1],
      [5, 2, 4, 3, 3, 1, 1],
      [5, 4, 4, 4, 3, 3, 3],
      [5, 4, 4, 6, 6, 6, 3],
      [5, 5, 5, 6, 6, 6, 6],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 15),
    ],
  );

  /// Stage 20: River Bend Falls (Chapter 4: Willow Brook - 7x7, 62 solution(s))
  static const StageDefinition stage20 = StageDefinition(
    id: 'stage-020',
    stageNumber: 20,
    name: 'River Bend Falls',
    biomeName: 'Riverbank',
    size: 7,
    chapterNumber: 4,
    chapterName: 'Willow Brook',
    storySpeaker: 'River',
    speakerEmoji: '🦦',
    storyTextEn: 'The grand misty waterfall echoing through the canyon.',
    storyTextTh: 'น้ำตกสายใหญ่ที่โค้งน้ำ ละอองน้ำเย็นฉ่ำตระการตา',
    rewardCritterId: 'river',
    baseAcornsReward: 35,
    description: 'The grand misty waterfall echoing through the canyon.',
    habitatGrid: [
      [3, 0, 0, 0, 0, 0, 0],
      [3, 3, 1, 1, 1, 0, 0],
      [3, 3, 1, 1, 1, 2, 2],
      [3, 4, 4, 4, 1, 1, 2],
      [3, 4, 4, 5, 5, 2, 2],
      [3, 6, 4, 5, 5, 5, 2],
      [6, 6, 6, 6, 5, 5, 2],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 16),
    ],
  );

  /// Stage 21: Golden Canopy (Chapter 5: Autumn Hollow - 7x7, 93 solution(s))
  static const StageDefinition stage21 = StageDefinition(
    id: 'stage-021',
    stageNumber: 21,
    name: 'Golden Canopy',
    biomeName: 'Maple Woods',
    size: 7,
    chapterNumber: 5,
    chapterName: 'Autumn Hollow',
    storySpeaker: 'Fawn',
    speakerEmoji: '🦌',
    storyTextEn: 'Autumn has arrived! Crimson and gold leaves swirl around.',
    storyTextTh: 'ฤดูใบไม้ร่วงมาถึงแล้ว ใบไม้สีแดงส้มปลิวไสวตามสายลม',
    rewardCritterId: 'fawn',
    baseAcornsReward: 30,
    description: 'Autumn has arrived! Crimson and gold leaves swirl around.',
    habitatGrid: [
      [0, 0, 0, 0, 0, 0, 0],
      [0, 2, 2, 1, 1, 1, 1],
      [2, 2, 2, 1, 1, 3, 3],
      [2, 2, 2, 1, 3, 3, 3],
      [4, 4, 4, 4, 3, 5, 5],
      [4, 6, 4, 4, 6, 5, 5],
      [4, 6, 6, 6, 6, 6, 5],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 15),
    ],
  );

  /// Stage 22: Maple Drift (Chapter 5: Autumn Hollow - 7x7, 118 solution(s))
  static const StageDefinition stage22 = StageDefinition(
    id: 'stage-022',
    stageNumber: 22,
    name: 'Maple Drift',
    biomeName: 'Maple Woods',
    size: 7,
    chapterNumber: 5,
    chapterName: 'Autumn Hollow',
    storySpeaker: 'Fawn',
    speakerEmoji: '🦌',
    storyTextEn: 'Crunching through piles of sweet-smelling maple leaves.',
    storyTextTh: 'เดินลุยไปในกองใบเมเปิ้ลสีส้มสดใส เสียงกรอบแกรบเพลินใจ',
    rewardCritterId: 'fawn',
    baseAcornsReward: 30,
    description: 'Crunching through piles of sweet-smelling maple leaves.',
    habitatGrid: [
      [1, 1, 0, 0, 0, 0, 0],
      [1, 1, 2, 2, 2, 0, 0],
      [1, 1, 1, 2, 2, 2, 2],
      [3, 3, 3, 3, 4, 4, 5],
      [3, 3, 6, 4, 4, 5, 5],
      [6, 6, 6, 4, 4, 5, 5],
      [6, 6, 6, 6, 4, 5, 5],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 15),
    ],
  );

  /// Stage 23: Amber Glade (Chapter 5: Autumn Hollow - 7x7, 115 solution(s))
  static const StageDefinition stage23 = StageDefinition(
    id: 'stage-023',
    stageNumber: 23,
    name: 'Amber Glade',
    biomeName: 'Maple Woods',
    size: 7,
    chapterNumber: 5,
    chapterName: 'Autumn Hollow',
    storySpeaker: 'Fawn',
    speakerEmoji: '🦌',
    storyTextEn: 'Fawn leads us to a sunlit grove filled with autumn berries.',
    storyTextTh: 'ลูกกวาง Fawn พามายังดงผลเบอร์รี่ป่าแสนหวานใต้แสงแดดอุ่น',
    rewardCritterId: 'fawn',
    baseAcornsReward: 35,
    description: 'Fawn leads us to a sunlit grove filled with autumn berries.',
    habitatGrid: [
      [0, 0, 0, 2, 1, 1, 1],
      [0, 0, 2, 2, 2, 4, 1],
      [0, 0, 3, 2, 2, 4, 1],
      [3, 3, 3, 2, 2, 4, 1],
      [3, 3, 5, 4, 4, 4, 1],
      [3, 5, 5, 5, 6, 6, 6],
      [5, 5, 5, 5, 6, 6, 6],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 16),
    ],
  );

  /// Stage 24: Harvest Feast (Chapter 5: Autumn Hollow - 7x7, 126 solution(s))
  static const StageDefinition stage24 = StageDefinition(
    id: 'stage-024',
    stageNumber: 24,
    name: 'Harvest Feast',
    biomeName: 'Maple Woods',
    size: 7,
    chapterNumber: 5,
    chapterName: 'Autumn Hollow',
    storySpeaker: 'Fawn',
    speakerEmoji: '🦌',
    storyTextEn: 'Critters gathered together sharing delicious camp pies.',
    storyTextTh: 'งานเลี้ยงฉลองการเก็บเกี่ยว ทุกคนแบ่งปันขนมอบแสนอร่อย',
    rewardCritterId: 'fawn',
    baseAcornsReward: 35,
    description: 'Critters gathered together sharing delicious camp pies.',
    habitatGrid: [
      [1, 1, 0, 0, 0, 0, 0],
      [1, 1, 1, 3, 0, 0, 0],
      [1, 1, 1, 3, 2, 2, 2],
      [4, 4, 4, 3, 3, 2, 2],
      [4, 4, 4, 3, 3, 2, 2],
      [4, 6, 6, 6, 5, 5, 5],
      [6, 6, 6, 6, 5, 5, 5],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 16),
    ],
  );

  /// Stage 25: Twilight Ridge (Chapter 5: Autumn Hollow - 7x7, 118 solution(s))
  static const StageDefinition stage25 = StageDefinition(
    id: 'stage-025',
    stageNumber: 25,
    name: 'Twilight Ridge',
    biomeName: 'Maple Woods',
    size: 7,
    chapterNumber: 5,
    chapterName: 'Autumn Hollow',
    storySpeaker: 'Fawn',
    speakerEmoji: '🦌',
    storyTextEn: 'Watching the crimson autumn sunset over misty mountain peaks.',
    storyTextTh: 'ชมพระอาทิตย์ตกดินเหนือทิวเขาหมอก สีสันงดงามจับใจ',
    rewardCritterId: 'fawn',
    baseAcornsReward: 40,
    description: 'Watching the crimson autumn sunset over misty mountain peaks.',
    habitatGrid: [
      [2, 1, 1, 1, 0, 0, 0],
      [2, 2, 1, 1, 1, 0, 0],
      [2, 2, 2, 1, 1, 0, 0],
      [2, 2, 5, 4, 4, 3, 3],
      [6, 5, 5, 4, 4, 3, 3],
      [6, 6, 5, 5, 4, 3, 3],
      [6, 6, 5, 5, 4, 4, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 17),
    ],
  );

  /// Stage 26: Starlit Staircase (Chapter 6: Starry Summit - 7x7, 106 solution(s))
  static const StageDefinition stage26 = StageDefinition(
    id: 'stage-026',
    stageNumber: 26,
    name: 'Starlit Staircase',
    biomeName: 'Mountain Peak',
    size: 7,
    chapterNumber: 6,
    chapterName: 'Starry Summit',
    storySpeaker: 'Luna',
    speakerEmoji: '🦉',
    storyTextEn: 'Climbing up the starry mountain trail above the clouds.',
    storyTextTh: 'ก้าวขึ้นบันไดหินโบราณสู่ยอดเขา ท่ามกลางดวงดาวพร่างพราว',
    rewardCritterId: 'luna',
    baseAcornsReward: 35,
    description: 'Climbing up the starry mountain trail above the clouds.',
    habitatGrid: [
      [0, 0, 0, 0, 0, 0, 2],
      [0, 1, 1, 1, 1, 0, 2],
      [3, 3, 3, 1, 1, 2, 2],
      [3, 3, 3, 1, 2, 2, 2],
      [3, 3, 4, 4, 4, 5, 5],
      [4, 4, 4, 6, 4, 5, 5],
      [6, 6, 6, 6, 6, 6, 6],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 16),
    ],
  );

  /// Stage 27: Moonlit Plateau (Chapter 6: Starry Summit - 7x7, 103 solution(s))
  static const StageDefinition stage27 = StageDefinition(
    id: 'stage-027',
    stageNumber: 27,
    name: 'Moonlit Plateau',
    biomeName: 'Mountain Peak',
    size: 7,
    chapterNumber: 6,
    chapterName: 'Starry Summit',
    storySpeaker: 'Luna',
    speakerEmoji: '🦉',
    storyTextEn: 'A serene open clearing glowing with silver moonlight.',
    storyTextTh: 'ลานหินกว้างอาบแสงจันทร์สีเงินนวลตา อากาศบริสุทธิ์สดชื่น',
    rewardCritterId: 'luna',
    baseAcornsReward: 40,
    description: 'A serene open clearing glowing with silver moonlight.',
    habitatGrid: [
      [4, 0, 0, 0, 0, 1, 1],
      [4, 2, 0, 0, 1, 1, 1],
      [4, 2, 2, 2, 1, 1, 3],
      [4, 2, 2, 3, 3, 3, 3],
      [4, 4, 6, 6, 6, 3, 3],
      [4, 6, 6, 5, 5, 5, 5],
      [6, 6, 6, 5, 5, 5, 5],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 17),
    ],
  );

  /// Stage 28: Constellation Peak (Chapter 6: Starry Summit - 8x8, 935 solution(s))
  static const StageDefinition stage28 = StageDefinition(
    id: 'stage-028',
    stageNumber: 28,
    name: 'Constellation Peak',
    biomeName: 'Mountain Peak',
    size: 8,
    chapterNumber: 6,
    chapterName: 'Starry Summit',
    storySpeaker: 'Luna',
    speakerEmoji: '🦉',
    storyTextEn: 'Luna points out stars arranged like our critter friends!',
    storyTextTh: 'นกฮูก Luna ชี้ชวนดูกลุ่มดาวบนฟากฟ้า รูปทรงเพื่อนน้องสัตว์',
    rewardCritterId: 'luna',
    baseAcornsReward: 45,
    description: 'Luna points out stars arranged like our critter friends!',
    habitatGrid: [
      [1, 1, 0, 0, 0, 2, 2, 2],
      [1, 1, 1, 0, 0, 2, 2, 2],
      [1, 1, 3, 0, 0, 0, 2, 2],
      [1, 3, 3, 3, 5, 4, 4, 4],
      [3, 3, 3, 5, 5, 4, 4, 4],
      [6, 6, 5, 5, 5, 7, 4, 7],
      [6, 6, 6, 5, 5, 7, 7, 7],
      [6, 6, 6, 6, 5, 7, 7, 7],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 20),
    ],
  );

  /// Stage 29: Meteor Shower (Chapter 6: Starry Summit - 8x8, 387 solution(s))
  static const StageDefinition stage29 = StageDefinition(
    id: 'stage-029',
    stageNumber: 29,
    name: 'Meteor Shower',
    biomeName: 'Mountain Peak',
    size: 8,
    chapterNumber: 6,
    chapterName: 'Starry Summit',
    storySpeaker: 'Luna',
    speakerEmoji: '🦉',
    storyTextEn: 'Make a wish! Brilliant shooting stars streak across the sky.',
    storyTextTh: 'อธิษฐานเร็ว! ฝนดาวตกสว่างไสวพาดผ่านฟากฟ้ายามค่ำคืน',
    rewardCritterId: 'luna',
    baseAcornsReward: 45,
    description: 'Make a wish! Brilliant shooting stars streak across the sky.',
    habitatGrid: [
      [1, 1, 0, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 2, 2, 0, 5],
      [1, 1, 3, 2, 2, 2, 5, 5],
      [3, 3, 3, 2, 2, 4, 5, 5],
      [3, 3, 6, 2, 4, 4, 5, 5],
      [3, 3, 6, 4, 4, 4, 7, 5],
      [6, 6, 6, 6, 4, 4, 7, 5],
      [6, 6, 6, 6, 7, 7, 7, 7],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 20),
    ],
  );

  /// Stage 30: Campers' Aurora (Chapter 6: Starry Summit - 8x8, 776 solution(s))
  static const StageDefinition stage30 = StageDefinition(
    id: 'stage-030',
    stageNumber: 30,
    name: 'Campers\' Aurora',
    biomeName: 'Mountain Peak',
    size: 8,
    chapterNumber: 6,
    chapterName: 'Starry Summit',
    storySpeaker: 'Luna',
    speakerEmoji: '🦉',
    storyTextEn: 'The grand Aurora Borealis shines bright! Our camp is complete!',
    storyTextTh: 'แสงเหนือออโรร่าสีเขียวมรกตฉลองความสำเร็จ! แคมป์ในฝันสำเร็จแล้ว!',
    rewardCritterId: 'luna',
    baseAcornsReward: 50,
    description: 'The grand Aurora Borealis shines bright! Our camp is complete!',
    habitatGrid: [
      [2, 2, 0, 0, 1, 1, 1, 1],
      [2, 0, 0, 0, 1, 1, 1, 1],
      [2, 2, 0, 0, 3, 3, 3, 3],
      [2, 4, 0, 3, 3, 3, 3, 3],
      [4, 4, 4, 4, 5, 5, 7, 7],
      [4, 4, 6, 5, 5, 5, 7, 7],
      [4, 6, 6, 6, 5, 7, 7, 7],
      [6, 6, 6, 6, 5, 5, 7, 7],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 22),
    ],
  );

  /// List of all 30 Adventure Stages.
  static const List<StageDefinition> allStages = [
    stage1,
    stage2,
    stage3,
    stage4,
    stage5,
    stage6,
    stage7,
    stage8,
    stage9,
    stage10,
    stage11,
    stage12,
    stage13,
    stage14,
    stage15,
    stage16,
    stage17,
    stage18,
    stage19,
    stage20,
    stage21,
    stage22,
    stage23,
    stage24,
    stage25,
    stage26,
    stage27,
    stage28,
    stage29,
    stage30,
  ];

  static StageDefinition getByNumber(int number) {
    if (number < 1) return stage1;
    if (number > allStages.length) return allStages.last;
    return allStages[number - 1];
  }

  static StageDefinition getById(String id) {
    return allStages.firstWhere(
      (s) => s.id == id,
      orElse: () => stage1,
    );
  }
}
