import 'package:flutter/material.dart';
import '../models/art_style.dart';
import '../utils/constants.dart';

class StyleSelector extends StatelessWidget {
  final ArtStyle selectedStyle;
  final Function(ArtStyle) onStyleSelected;

  const StyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ArtStyle.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final style = ArtStyle.values[index];
          final isSelected = style == selectedStyle;

          return GestureDetector(
            onTap: () => onStyleSelected(style),
            child: AnimatedContainer(
              duration: AppSizes.animShort,
              width: 120,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gold.withOpacity(0.2)
                    : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.gold : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIcon(style),
                    size: 40,
                    color:
                        isSelected ? AppColors.gold : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    style.displayName,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isSelected ? AppColors.gold : AppColors.textSecondary,
                      fontFamily: 'Handwritten',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(ArtStyle style) {
    switch (style) {
      case ArtStyle.aquarel:
        return Icons.water_drop;
      case ArtStyle.oil:
        return Icons.palette;
      case ArtStyle.pixel:
        return Icons.grid_4x4;
      case ArtStyle.engraving:
        return Icons.texture;
    }
  }
}
