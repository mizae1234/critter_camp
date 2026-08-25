import '../../core/storage/local_storage.dart';
import '../models/player_profile.dart';
import '../mock/mock_player_data.dart';

abstract class AuthRepository {
  Future<PlayerProfile> getCurrentProfile();
  Future<void> login(String username);
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  final LocalStorage storage;

  MockAuthRepository(this.storage);

  @override
  Future<PlayerProfile> getCurrentProfile() async {
    return MockPlayerData.defaultProfile;
  }

  @override
  Future<void> login(String username) async {
    await storage.setUsername(username);
  }

  @override
  Future<void> logout() async {
    // Guest state
  }
}
