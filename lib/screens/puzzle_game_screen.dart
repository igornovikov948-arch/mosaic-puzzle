import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/puzzle.dart';
import '../models/puzzle_piece.dart';
import '../services/puzzle_storage.dart';
import '../services/audio_manager.dart';
import '../services/haptic_manager.dart';
import '../utils/constants.dart';
import '../widgets/puzzle_board.dart';
import 'puzzle_complete_screen.dart';

class PuzzleGameScreen extends StatefulWidget {
  final Puzzle puzzle;

  const PuzzleGameScreen({super.key, required this.puzzle});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  late Puzzle _puzzle;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _puzzle = widget.puzzle;
    _completedCount = _puzzle.completedPieces;
  }

  void _onPiecePlaced(PuzzlePiece piece) {
    setState(() {
      _completedCount++;
    });

    AudioManager.playSnap();
    HapticManager.medium();

    // Проверить завершение
    if (_completedCount >= _puzzle.totalPieces) {
      _onPuzzleComplete();
    }
  }

  void _onPuzzleComplete() {
    AudioManager.playComplete();
    HapticManager.heavy();

    final completedPuzzle = _puzzle.copyWith(
      isCompleted: true,
      completedPieces: _puzzle.totalPieces,
    );
    PuzzleStorage.updatePuzzle(completedPuzzle);

    // Задержка перед переходом на экран завершения
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PuzzleCompleteScreen(puzzle: completedPuzzle),
          ),
        );
      }
    });
  }

  void _showHint() {
    // Подсветить неприкреплённые кусочки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Осталось собрать: ${_puzzle.totalPieces - _completedCount} кусочков',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          '${loc.translate('inProgress')} $_completedCount/${_puzzle.totalPieces}',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _showHint,
            tooltip: loc.translate('hint'),
          ),
        ],
      ),
      body: PuzzleBoard(
        puzzle: _puzzle,
        onPiecePlaced: _onPiecePlaced,
      ),
    );
  }
}
