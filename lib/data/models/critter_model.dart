class CritterModel {
  final String id;
  final String name;
  final String title;
  final String species;
  final String biome;
  final String emoji;
  final String bio;
  final String favoriteFood;
  final String perkDescription;
  final int unlockLevel;
  final bool isUnlocked;

  const CritterModel({
    required this.id,
    required this.name,
    required this.title,
    required this.species,
    required this.biome,
    required this.emoji,
    required this.bio,
    required this.favoriteFood,
    required this.perkDescription,
    required this.unlockLevel,
    this.isUnlocked = false,
  });

  CritterModel copyWith({bool? isUnlocked}) {
    return CritterModel(
      id: id,
      name: name,
      title: title,
      species: species,
      biome: biome,
      emoji: emoji,
      bio: bio,
      favoriteFood: favoriteFood,
      perkDescription: perkDescription,
      unlockLevel: unlockLevel,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
