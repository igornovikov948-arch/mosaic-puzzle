import 'dart:io';
import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../models/puzzle_piece.dart';
import '../services/audio_manager.dart';
import '../services/haptic_manager.dart';
import '../utils/constants.dart';
import 'puzzle_piece_widget.dart';

class PuzzleBoard extends StatefulWidget {
  final Puzzle puzzle;
  final Function(PuzzlePiece piece) onPiecePlaced;

  const PuzzleBoard({
    super.key,
    required this.puzzle,
    required this.onPiecePlaced,
  });

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  late List<PuzzlePiece> _pieces;
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _pieces = List.from(widget.puzzle.pieces);
  }

  void _onPieceDragUpdate(int pieceId, Offset delta) {
    setState(() {
      final piece = _pieces.firstWhere((p) => p.id == pieceId);
      piece.currentX += delta.dx;
      piece.currentY += delta.dy;
    });
  }

  void _onPieceDragEnd(int pieceId) {
    final piece = _pieces.firstWhere((p) => p.id == pieceId);

    // Проверить примагничивание
    if (piece.isNearCorrectPosition(AppSizes.snapDistance)) {
      setState(() {
        piece.snapToCorrect();
      });
      widget.onPiecePlaced(piece);
    }
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformController,
      minScale: 0.5,
      maxScale: 3.0,
      boundaryMargin: const EdgeInsets.all(200),
      child: SizedBox(
        width: 900,
        height: 900,
        child: Stack(
          children: [
            // Фон — деревянный стол
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),

            // Силуэт картинки (опционально)
            if (File(widget.puzzle.photoPath).existsSync())
              Opacity(
                opacity: 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(widget.puzzle.photoPath),
                    width: 800,
                    height: 800,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Кусочки
            ..._pieces.where((p) => !p.isPlaced).map((piece) {
              return PuzzlePieceWidget(
                piece: piece,
                onDragUpdate: (delta) => _onPieceDragUpdate(piece.id, delta),
                onDragEnd: () => _onPieceDragEnd(piece.id),
              );
            }),
          ],
        ),
      ),
    );
  }
}
