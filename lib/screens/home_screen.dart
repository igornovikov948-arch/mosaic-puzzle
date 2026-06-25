import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/puzzle.dart';
import '../services/puzzle_storage.dart';
import '../utils/constants.dart';
import 'create_puzzle_screen.dart';
import 'puzzle_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Puzzle> _puzzles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPuzzles();
  }

  Future<void> _loadPuzzles() async {
    final puzzles = await PuzzleStorage.loadAll();
    if (mounted) {
      setState(() {
        _puzzles = puzzles;
        _loading = false;
      });
    }
  }

  void _openPuzzle(Puzzle puzzle) {
    if (puzzle.isCompleted) {
      // Открыть просмотр собранного пазла
    } else {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => PuzzleGameScreen(puzzle: puzzle),
            ),
          )
          .then((_) => _loadPuzzles());
    }
  }

  void _deletePuzzle(Puzzle puzzle) async {
    final loc = context.loc;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(loc.translate('deleteConfirm'),
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('delete'),
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await PuzzleStorage.deletePuzzle(puzzle.id);
      _loadPuzzles();
    }
  }

  void _createPuzzle() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreatePuzzleScreen()),
    );
    _loadPuzzles();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          loc.translate('myPuzzles'),
          style: const TextStyle(fontFamily: 'Handwritten', fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold))
          : _puzzles.isEmpty
              ? _buildEmptyState(loc)
              : _buildPuzzleGrid(loc),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPuzzle,
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.backgroundDark,
        icon: const Icon(Icons.add),
        label: Text(loc.translate('createPuzzle')),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined,
                size: 80, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(loc.translate('noPuzzlesYet'),
                style: TextStyle(fontSize: 20, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(loc.translate('noPuzzlesDescription'),
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.7)),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleGrid(AppLocalizations loc) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSizes.homeGridColumns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: AppSizes.homeCardRatio,
      ),
      itemCount: _puzzles.length,
      itemBuilder: (context, index) {
        final puzzle = _puzzles[index];
        return _buildPuzzleCard(puzzle, loc);
      },
    );
  }

  Widget _buildPuzzleCard(Puzzle puzzle, AppLocalizations loc) {
    final photoExists = File(puzzle.photoPath).existsSync();

    return GestureDetector(
      onTap: () => _openPuzzle(puzzle),
      onLongPress: () => _deletePuzzle(puzzle),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: puzzle.isCompleted
                ? AppColors.gold.withOpacity(0.5)
                : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            // Миниатюра
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: photoExists
                    ? Image.file(File(puzzle.photoPath), fit: BoxFit.cover)
                    : Container(color: AppColors.backgroundDark),
              ),
            ),
            // Прогресс
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: puzzle.progress,
                    backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                    color:
                        puzzle.isCompleted ? AppColors.gold : AppColors.emerald,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    puzzle.isCompleted
                        ? loc.translate('completed')
                        : '${(puzzle.progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 11,
                      color: puzzle.isCompleted
                          ? AppColors.gold
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
