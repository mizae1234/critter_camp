import '../../core/storage/local_storage.dart';
import '../models/critter_model.dart';
import '../mock/mock_critter_data.dart';

abstract class CollectionRepository {
  Future<List<CritterModel>> getCritters();
  Future<void> unlockCritter(String critterId);
}

class LocalCollectionRepository implements CollectionRepository {
  final LocalStorage storage;

  LocalCollectionRepository(this.storage);

  @override
  Future<List<CritterModel>> getCritters() async {
    final unlockedIds = storage.getUnlockedCritters();
    return MockCritterData.critters.map((c) {
      return c.copyWith(isUnlocked: unlockedIds.contains(c.id));
    }).toList();
  }

  @override
  Future<void> unlockCritter(String critterId) async {
    await storage.unlockCritter(critterId);
  }
}
