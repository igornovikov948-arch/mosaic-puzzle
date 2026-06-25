import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';
import '../services/audio_manager.dart';
import '../services/haptic_manager.dart';
import '../utils/constants.dart';

class PuzzlePieceWidget extends StatefulWidget {
  final PuzzlePiece piece;
  final Function(Offset delta) onDragUpdate;
  final VoidCallback onDragEnd;

  const PuzzlePieceWidget({
    super.key,
    required this.piece,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  State<PuzzlePieceWidget> createState() => _PuzzlePieceWidgetState();
}

class _PuzzlePieceWidgetState extends State<PuzzlePieceWidget> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final piece = widget.piece;

    return Positioned(
      left: piece.currentX - 40,
      top: piece.currentY - 40,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() => _isDragging = true);
          AudioManager.playPickup();
          HapticManager.light();
        },
        onPanUpdate: (details) {
          widget.onDragUpdate(details.delta);
        },
        onPanEnd: (_) {
          setState(() => _isDragging = false);
          widget.onDragEnd();
        },
        child: AnimatedContainer(
          duration: AppSizes.animShort,
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _isDragging
                ? AppColors.gold.withOpacity(0.8)
                : AppColors.gold.withOpacity(0.6),
            borderRadius: BorderRadius.circular(AppSizes.pieceBorderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark,
                blurRadius: _isDragging ? 12 : AppSizes.pieceShadow,
                offset: Offset(0, _isDragging ? 4 : 2),
              ),
            ],
            border: Border.all(
              color: AppColors.gold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '${piece.id + 1}',
              style: TextStyle(
                color: AppColors.backgroundDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
