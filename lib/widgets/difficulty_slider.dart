import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';

class DifficultySlider extends StatelessWidget {
  final int value;
  final Function(int) onChanged;

  const DifficultySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Column(
      children: [
        // Текущее значение
        Text(
          loc.translate('piecesCount', args: {'count': value.toString()}),
          style: TextStyle(
            fontSize: 28,
            color: AppColors.gold,
            fontFamily: 'Handwritten',
          ),
        ),
        const SizedBox(height: 24),

        // Ползунок
        Slider(
          value: value.toDouble(),
          min: AppSizes.minPieces.toDouble(),
          max: AppSizes.maxPieces.toDouble(),
          divisions: (AppSizes.maxPieces - AppSizes.minPieces) ~/ 4,
          onChanged: (v) => onChanged(v.round()),
        ),
        const SizedBox(height: 8),

        // Метки мин/макс
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppSizes.minPieces}',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            Text(
              '${AppSizes.maxPieces}',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Ручной ввод
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: value > AppSizes.minPieces
                  ? () => onChanged(value - 5)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.gold,
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.gold.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.gold),
                  ),
                ),
                onSubmitted: (text) {
                  final number = int.tryParse(text);
                  if (number != null) {
                    onChanged(
                        number.clamp(AppSizes.minPieces, AppSizes.maxPieces));
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: value < AppSizes.maxPieces
                  ? () => onChanged(value + 5)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.gold,
            ),
          ],
        ),
      ],
    );
  }
}
