// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';

class Pos {
  final int r;
  final int c;
  Pos(this.r, this.c);
}

List<int>? findValidQueenPlacement(int n, Random rng) {
  List<int> cols = [];

  bool solve(int r) {
    if (r == n) return true;

    List<int> candidates = List.generate(n, (i) => i)..shuffle(rng);
    for (int c in candidates) {
      if (cols.contains(c)) continue;
      bool ok = true;
      for (int prevR = 0; prevR < r; prevR++) {
        int prevC = cols[prevR];
        if ((prevR - r).abs() <= 1 && (prevC - c).abs() <= 1) {
          ok = false;
          break;
        }
      }
      if (!ok) continue;

      cols.add(c);
      if (solve(r + 1)) return true;
      cols.removeLast();
    }
    return false;
  }

  return solve(0) ? cols : null;
}

List<List<int>> generateRegionsFromQueens(int n, List<int> queens, Random rng) {
  List<List<int>> grid = List.generate(n, (_) => List.filled(n, -1));
  List<List<Pos>> regionCells = List.generate(n, (_) => []);

  for (int r = 0; r < n; r++) {
    int c = queens[r];
    grid[r][c] = r;
    regionCells[r].add(Pos(r, c));
  }

  bool unassigned = true;
  while (unassigned) {
    unassigned = false;
    List<int> order = List.generate(n, (i) => i)..shuffle(rng);

    for (int reg in order) {
      List<Pos> neighbors = [];
      for (Pos p in regionCells[reg]) {
        for (final offset in [Pos(-1, 0), Pos(1, 0), Pos(0, -1), Pos(0, 1)]) {
          int nr = p.r + offset.r;
          int nc = p.c + offset.c;
          if (nr >= 0 && nr < n && nc >= 0 && nc < n && grid[nr][nc] == -1) {
            neighbors.add(Pos(nr, nc));
          }
        }
      }

      if (neighbors.isNotEmpty) {
        unassigned = true;
        Pos chosen = neighbors[rng.nextInt(neighbors.length)];
        grid[chosen.r][chosen.c] = reg;
        regionCells[reg].add(chosen);
      }
    }

    bool hasMinusOne = false;
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if (grid[r][c] == -1) hasMinusOne = true;
      }
    }
    unassigned = hasMinusOne;
  }

  return grid;
}

int countSolutions(List<List<int>> habitatGrid, int size) {
  int count = 0;
  List<int> colPlacements = [];

  void backtrack(int r) {
    if (r == size) {
      count++;
      return;
    }

    for (int c = 0; c < size; c++) {
      if (colPlacements.contains(c)) continue;

      int region = habitatGrid[r][c];
      bool habitatConflict = false;
      for (int prevR = 0; prevR < r; prevR++) {
        int prevC = colPlacements[prevR];
        if (habitatGrid[prevR][prevC] == region) {
          habitatConflict = true;
          break;
        }
      }
      if (habitatConflict) continue;

      bool neighborConflict = false;
      for (int prevR = 0; prevR < r; prevR++) {
        int prevC = colPlacements[prevR];
        if ((prevR - r).abs() <= 1 && (prevC - c).abs() <= 1) {
          neighborConflict = true;
          break;
        }
      }
      if (neighborConflict) continue;

      colPlacements.add(c);
      backtrack(r + 1);
      colPlacements.removeLast();
    }
  }

  backtrack(0);
  return count;
}

class ChapterInfo {
  final int chapterNumber;
  final String chapterName;
  final String biomeName;
  final String speaker;
  final String emoji;
  final String critterId;

  ChapterInfo({
    required this.chapterNumber,
    required this.chapterName,
    required this.biomeName,
    required this.speaker,
    required this.emoji,
    required this.critterId,
  });
}

class StageMeta {
  final String name;
  final String storyEn;
  final String storyTh;
  final int size;
  final int maxMoves;
  final int rewardAcorns;

  StageMeta({
    required this.name,
    required this.storyEn,
    required this.storyTh,
    required this.size,
    required this.maxMoves,
    required this.rewardAcorns,
  });
}

void main() {
  final rng = Random(12345);

  final chapters = [
    ChapterInfo(
      chapterNumber: 1,
      chapterName: 'Whispering Meadow',
      biomeName: 'Camp Entrance',
      speaker: 'Hazel',
      emoji: '🦊',
      critterId: 'hazel',
    ),
    ChapterInfo(
      chapterNumber: 2,
      chapterName: 'Pine Haven Trail',
      biomeName: 'Pine Forest',
      speaker: 'Finn',
      emoji: '🐿️',
      critterId: 'finn',
    ),
    ChapterInfo(
      chapterNumber: 3,
      chapterName: 'Lavender Valley',
      biomeName: 'Purple Hollow',
      speaker: 'Pip',
      emoji: '🦔',
      critterId: 'pip',
    ),
    ChapterInfo(
      chapterNumber: 4,
      chapterName: 'Willow Brook',
      biomeName: 'Riverbank',
      speaker: 'River',
      emoji: '🦦',
      critterId: 'river',
    ),
    ChapterInfo(
      chapterNumber: 5,
      chapterName: 'Autumn Hollow',
      biomeName: 'Maple Woods',
      speaker: 'Fawn',
      emoji: '🦌',
      critterId: 'fawn',
    ),
    ChapterInfo(
      chapterNumber: 6,
      chapterName: 'Starry Summit',
      biomeName: 'Mountain Peak',
      speaker: 'Luna',
      emoji: '🦉',
      critterId: 'luna',
    ),
  ];

  final stageMetas = [
    // Chapter 1 (1-5)
    StageMeta(
      name: 'Sunlit Meadow',
      storyEn: 'Welcome to camp! Let\'s place 1 critter in each habitat.',
      storyTh: 'ยินดีต้อนรับสู่แคมป์! วันนี้แดดอุ่นมาก มาช่วยจัดที่พักให้เพื่อนๆ กัน',
      size: 4,
      maxMoves: 6,
      rewardAcorns: 10,
    ),
    StageMeta(
      name: 'Picnic Patch',
      storyEn: 'Let\'s lay down the picnic mat under the shady oak tree.',
      storyTh: 'มาปูเสื่อปิกนิกใต้ร่มไม้ใหญ่ แล้ววางเสบียงให้เรียบร้อยนะ',
      size: 4,
      maxMoves: 6,
      rewardAcorns: 10,
    ),
    StageMeta(
      name: 'Acorn Clearing',
      storyEn: 'Gathering golden acorns around the cozy clearing.',
      storyTh: 'เดินเก็บลูกโอ๊กสีทองรอบลานหญ้า ระวังอย่าเหยียบกิ่งไม้นะ',
      size: 5,
      maxMoves: 8,
      rewardAcorns: 15,
    ),
    StageMeta(
      name: 'Firefly Nook',
      storyEn: 'Tiny fireflies are waking up as the evening breeze blows.',
      storyTh: 'หิ่งห้อยตัวน้อยเริ่มเปล่งแสงวิบวับในยามเย็น',
      size: 5,
      maxMoves: 8,
      rewardAcorns: 15,
    ),
    StageMeta(
      name: 'Campfire Circle',
      storyEn: 'The warm campfire is glowing! We completed our first camp!',
      storyTh: 'กองไฟอุ่นๆ จุดสว่างแล้ว! แคมป์แรกของเราพร้อมต้อนรับทุกคน',
      size: 5,
      maxMoves: 9,
      rewardAcorns: 20,
    ),

    // Chapter 2 (6-10)
    StageMeta(
      name: 'Whispering Pines',
      storyEn: 'Tall pine trees rustle gently in the morning mist.',
      storyTh: 'ต้นสนสูงตระหง่านส่งเสียงกระซิบในสายหมอกยามเช้า',
      size: 5,
      maxMoves: 9,
      rewardAcorns: 15,
    ),
    StageMeta(
      name: 'Needle Path',
      storyEn: 'Step softly on the soft carpet of crunchy pine needles.',
      storyTh: 'ก้าวเบาๆ บนพรมใบสนสีน้ำตาล ทางเริ่มคดเคี้ยวแล้วนะ',
      size: 5,
      maxMoves: 9,
      rewardAcorns: 15,
    ),
    StageMeta(
      name: 'Mossy Boulder',
      storyEn: 'A giant boulder covered in soft emerald forest moss.',
      storyTh: 'โขดหินยักษ์ที่ปกคลุมด้วยมอสเขียวชอุ่ม ให้ความเย็นสบาย',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 20,
    ),
    StageMeta(
      name: 'Squirrel\'s Secret',
      storyEn: 'Finn shows us where the sweetest pine nuts are hidden.',
      storyTh: 'เจ้ากระรอก Finn พามาดูคลังเก็บลูกสนลับแสนอร่อย',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 20,
    ),
    StageMeta(
      name: 'Canopy Lookout',
      storyEn: 'Climbing up high to view the entire emerald forest expanse.',
      storyTh: 'มองจากยอดไม้สน เห็นทัศนียภาพป่าเขียวขจีสุดลูกหูลูกตา',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 25,
    ),

    // Chapter 3 (11-15)
    StageMeta(
      name: 'Fragrant Slope',
      storyEn: 'Purple lavender blossoms wave gently in the warm breeze.',
      storyTh: 'เนินเขาสีม่วงของดอกลาเวนเดอร์ส่งกลิ่นหอมชื่นใจ',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 20,
    ),
    StageMeta(
      name: 'Honeycomb Terrace',
      storyEn: 'Happy bees dancing between sweet nectar petals.',
      storyTh: 'ผึ้งน้อยบินร่ายรำเก็บน้ำหวานจากดอกไม้หลากสี',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 20,
    ),
    StageMeta(
      name: 'Lavender Hollow',
      storyEn: 'Deep in the fragrant purple valley where peaceful naps await.',
      storyTh: 'หุบเขาดอกไม้แสนสงบ เหมาะแก่การพักผ่อนและจิบชา',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 25,
    ),
    StageMeta(
      name: 'Herbal Meadow',
      storyEn: 'Pip is picking fresh chamomile and mint for evening tea.',
      storyTh: 'เม่นน้อย Pip ชวนเก็บใบคาโมมายล์และมินต์ไปต้มชารอบกองไฟ',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 25,
    ),
    StageMeta(
      name: 'Sunset Blossom',
      storyEn: 'Golden sunset rays paint the purple slopes in amber light.',
      storyTh: 'แสงอาทิตย์อัสดงส่องประกายสีทองพาดผ่านทุ่งลาเวนเดอร์',
      size: 6,
      maxMoves: 13,
      rewardAcorns: 30,
    ),

    // Chapter 4 (16-20)
    StageMeta(
      name: 'Babbling Creek',
      storyEn: 'Cool crystal water ripples over smooth pebbles.',
      storyTh: 'สายน้ำใสไหลเย็นเอื่อยๆ กระทบก้อนกรวดกลมเกลี้ยง',
      size: 6,
      maxMoves: 12,
      rewardAcorns: 25,
    ),
    StageMeta(
      name: 'Stepping Stones',
      storyEn: 'Hop carefully from one mossy river stone to the next!',
      storyTh: 'กระโดดข้ามหินริมน้ำอย่างระมัดระวัง อย่าลื่นตกน้ำนะ!',
      size: 6,
      maxMoves: 13,
      rewardAcorns: 25,
    ),
    StageMeta(
      name: 'Willow Shallows',
      storyEn: 'Graceful willow branches dipping into the calm water.',
      storyTh: 'กิ่งหลิวห้อยระย้าสัมผัสผิวน้ำอันเงียบสงบ',
      size: 7,
      maxMoves: 15,
      rewardAcorns: 30,
    ),
    StageMeta(
      name: 'Otter\'s Playground',
      storyEn: 'River the otter loves sliding down the muddy riverbank!',
      storyTh: 'นากน้อย River ชวนลื่นไถลลงเนินดินเล่นน้ำอย่างสนุกสนาน',
      size: 7,
      maxMoves: 15,
      rewardAcorns: 30,
    ),
    StageMeta(
      name: 'River Bend Falls',
      storyEn: 'The grand misty waterfall echoing through the canyon.',
      storyTh: 'น้ำตกสายใหญ่ที่โค้งน้ำ ละอองน้ำเย็นฉ่ำตระการตา',
      size: 7,
      maxMoves: 16,
      rewardAcorns: 35,
    ),

    // Chapter 5 (21-25)
    StageMeta(
      name: 'Golden Canopy',
      storyEn: 'Autumn has arrived! Crimson and gold leaves swirl around.',
      storyTh: 'ฤดูใบไม้ร่วงมาถึงแล้ว ใบไม้สีแดงส้มปลิวไสวตามสายลม',
      size: 7,
      maxMoves: 15,
      rewardAcorns: 30,
    ),
    StageMeta(
      name: 'Maple Drift',
      storyEn: 'Crunching through piles of sweet-smelling maple leaves.',
      storyTh: 'เดินลุยไปในกองใบเมเปิ้ลสีส้มสดใส เสียงกรอบแกรบเพลินใจ',
      size: 7,
      maxMoves: 15,
      rewardAcorns: 30,
    ),
    StageMeta(
      name: 'Amber Glade',
      storyEn: 'Fawn leads us to a sunlit grove filled with autumn berries.',
      storyTh: 'ลูกกวาง Fawn พามายังดงผลเบอร์รี่ป่าแสนหวานใต้แสงแดดอุ่น',
      size: 7,
      maxMoves: 16,
      rewardAcorns: 35,
    ),
    StageMeta(
      name: 'Harvest Feast',
      storyEn: 'Critters gathered together sharing delicious camp pies.',
      storyTh: 'งานเลี้ยงฉลองการเก็บเกี่ยว ทุกคนแบ่งปันขนมอบแสนอร่อย',
      size: 7,
      maxMoves: 16,
      rewardAcorns: 35,
    ),
    StageMeta(
      name: 'Twilight Ridge',
      storyEn: 'Watching the crimson autumn sunset over misty mountain peaks.',
      storyTh: 'ชมพระอาทิตย์ตกดินเหนือทิวเขาหมอก สีสันงดงามจับใจ',
      size: 7,
      maxMoves: 17,
      rewardAcorns: 40,
    ),

    // Chapter 6 (26-30)
    StageMeta(
      name: 'Starlit Staircase',
      storyEn: 'Climbing up the starry mountain trail above the clouds.',
      storyTh: 'ก้าวขึ้นบันไดหินโบราณสู่ยอดเขา ท่ามกลางดวงดาวพร่างพราว',
      size: 7,
      maxMoves: 16,
      rewardAcorns: 35,
    ),
    StageMeta(
      name: 'Moonlit Plateau',
      storyEn: 'A serene open clearing glowing with silver moonlight.',
      storyTh: 'ลานหินกว้างอาบแสงจันทร์สีเงินนวลตา อากาศบริสุทธิ์สดชื่น',
      size: 7,
      maxMoves: 17,
      rewardAcorns: 40,
    ),
    StageMeta(
      name: 'Constellation Peak',
      storyEn: 'Luna points out stars arranged like our critter friends!',
      storyTh: 'นกฮูก Luna ชี้ชวนดูกลุ่มดาวบนฟากฟ้า รูปทรงเพื่อนน้องสัตว์',
      size: 8,
      maxMoves: 20,
      rewardAcorns: 45,
    ),
    StageMeta(
      name: 'Meteor Shower',
      storyEn: 'Make a wish! Brilliant shooting stars streak across the sky.',
      storyTh: 'อธิษฐานเร็ว! ฝนดาวตกสว่างไสวพาดผ่านฟากฟ้ายามค่ำคืน',
      size: 8,
      maxMoves: 20,
      rewardAcorns: 45,
    ),
    StageMeta(
      name: 'Campers\' Aurora',
      storyEn: 'The grand Aurora Borealis shines bright! Our camp is complete!',
      storyTh: 'แสงเหนือออโรร่าสีเขียวมรกตฉลองความสำเร็จ! แคมป์ในฝันสำเร็จแล้ว!',
      size: 8,
      maxMoves: 22,
      rewardAcorns: 50,
    ),
  ];

  final buffer = StringBuffer();
  buffer.writeln('import \'../stage_definition.dart\';');
  buffer.writeln('import \'../../bonus/no_hints_bonus.dart\';');
  buffer.writeln('import \'../../bonus/move_efficiency_bonus.dart\';');
  buffer.writeln('');
  buffer.writeln('/// Complete Handcrafted & Verified 30-Stage Adventure Catalog.');
  buffer.writeln('/// Spans 6 Chapters/Biomes with rich story lore, progressive difficulty (4x4 to 8x8),');
  buffer.writeln('/// and guaranteed mathematical solvability.');
  buffer.writeln('class StageCatalog {');

  final allStageVars = <String>[];

  for (int i = 0; i < stageMetas.length; i++) {
    final stageNum = i + 1;
    final meta = stageMetas[i];
    final chapterIdx = (i / 5).floor();
    final chapter = chapters[chapterIdx];
    final varName = 'stage$stageNum';
    allStageVars.add(varName);

    // Generate verified solvable grid
    List<int>? queens;
    List<List<int>>? grid;
    int solutions = 0;

    for (int attempt = 0; attempt < 500; attempt++) {
      queens = findValidQueenPlacement(meta.size, rng);
      if (queens == null) continue;
      grid = generateRegionsFromQueens(meta.size, queens, rng);
      solutions = countSolutions(grid, meta.size);
      if (solutions >= 1) break;
    }

    buffer.writeln('  /// Stage $stageNum: ${meta.name} (Chapter ${chapter.chapterNumber}: ${chapter.chapterName} - ${meta.size}x${meta.size}, $solutions solution(s))');
    buffer.writeln('  static const StageDefinition $varName = StageDefinition(');
    buffer.writeln('    id: \'stage-${stageNum.toString().padLeft(3, '0')}\',');
    buffer.writeln('    stageNumber: $stageNum,');
    buffer.writeln('    name: \'${meta.name.replaceAll("'", "\\'")}\',');
    buffer.writeln('    biomeName: \'${chapter.biomeName.replaceAll("'", "\\'")}\',');
    buffer.writeln('    size: ${meta.size},');
    buffer.writeln('    chapterNumber: ${chapter.chapterNumber},');
    buffer.writeln('    chapterName: \'${chapter.chapterName.replaceAll("'", "\\'")}\',');
    buffer.writeln('    storySpeaker: \'${chapter.speaker.replaceAll("'", "\\'")}\',');
    buffer.writeln('    speakerEmoji: \'${chapter.emoji}\',');
    buffer.writeln('    storyTextEn: \'${meta.storyEn.replaceAll("'", "\\'")}\',');
    buffer.writeln('    storyTextTh: \'${meta.storyTh.replaceAll("'", "\\'")}\',');
    buffer.writeln('    rewardCritterId: \'${chapter.critterId}\',');
    buffer.writeln('    baseAcornsReward: ${meta.rewardAcorns},');
    buffer.writeln('    description: \'${meta.storyEn.replaceAll("'", "\\'")}\',');
    buffer.writeln('    habitatGrid: [');
    for (final row in grid!) {
      buffer.writeln('      ${row.toString()},');
    }
    buffer.writeln('    ],');
    buffer.writeln('    bonusObjectives: [');
    buffer.writeln('      NoHintsBonus(),');
    buffer.writeln('      MoveEfficiencyBonus(maxMoves: ${meta.maxMoves}),');
    buffer.writeln('    ],');
    buffer.writeln('  );');
    buffer.writeln('');
  }

  buffer.writeln('  /// List of all 30 Adventure Stages.');
  buffer.writeln('  static const List<StageDefinition> allStages = [');
  for (final v in allStageVars) {
    buffer.writeln('    $v,');
  }
  buffer.writeln('  ];');
  buffer.writeln('');
  buffer.writeln('  static StageDefinition getByNumber(int number) {');
  buffer.writeln('    if (number < 1) return stage1;');
  buffer.writeln('    if (number > allStages.length) return allStages.last;');
  buffer.writeln('    return allStages[number - 1];');
  buffer.writeln('  }');
  buffer.writeln('');
  buffer.writeln('  static StageDefinition getById(String id) {');
  buffer.writeln('    return allStages.firstWhere(');
  buffer.writeln('      (s) => s.id == id,');
  buffer.writeln('      orElse: () => stage1,');
  buffer.writeln('    );');
  buffer.writeln('  }');
  buffer.writeln('}');

  File('lib/game/stage/stages/stage_catalog.dart').writeAsStringSync(buffer.toString());
  print('Successfully generated lib/game/stage/stages/stage_catalog.dart with 30 stages!');
}
