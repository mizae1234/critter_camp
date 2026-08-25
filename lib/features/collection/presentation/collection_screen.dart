import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../data/models/critter_model.dart';
import '../dialogs/critter_detail_modal.dart';

class CollectionScreen extends StatefulWidget {
  final List<CritterModel> critters;

  const CollectionScreen({super.key, required this.critters});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Forest Trail', 'Sunlit Meadow', 'Willow Brook', 'Ancient Hollow'];

    final filteredList = widget.critters.where((c) {
      if (_selectedFilter == 'All') return true;
      return c.biome == _selectedFilter;
    }).toList();

    final int unlockedCount = widget.critters.where((c) => c.isUnlocked).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Critters',
                        style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark),
                      ),
                      Text(
                        '$unlockedCount of ${widget.critters.length} Discovered',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      'Collection',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final bool isSelected = cat == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat),
                        labelStyle: AppTypography.labelSmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        backgroundColor: AppColors.surfaceContainerLow,
                        selectedColor: AppColors.primary,
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        onSelected: (val) {
                          setState(() {
                            _selectedFilter = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Critters Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final critter = filteredList[index];
                    return _buildCritterCard(critter);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCritterCard(CritterModel critter) {
    return CritterCard(
      onTap: critter.isUnlocked ? () => _openDetail(critter) : null,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CritterAvatar(
            emoji: critter.emoji,
            size: 60,
            isUnlocked: critter.isUnlocked,
          ),
          const SizedBox(height: 10),
          Text(
            critter.isUnlocked ? critter.name : 'Unknown Critter',
            style: AppTypography.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            critter.isUnlocked ? critter.title : 'Unlock at Level ${critter.unlockLevel}',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: critter.isUnlocked 
                  ? AppColors.secondaryContainer.withValues(alpha: 0.6) 
                  : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              critter.biome,
              style: AppTypography.labelSmall.copyWith(
                color: critter.isUnlocked ? AppColors.primaryDark : AppColors.outline,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(CritterModel critter) {
    showDialog(
      context: context,
      builder: (context) {
        return CritterDetailModal(
          critter: critter,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
