import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/puzzle.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class PuzzleCompleteScreen extends StatefulWidget {
  final Puzzle puzzle;

  const PuzzleCompleteScreen({super.key, required this.puzzle});

  @override
  State<PuzzleCompleteScreen> createState() => _PuzzleCompleteScreenState();
}

class _PuzzleCompleteScreenState extends State<PuzzleCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnim = Tween<double>(begin: 1.2, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: AppCurves.easeOut),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _playAgain() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final photoExists = File(widget.puzzle.photoPath).existsSync();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Собранная картинка
                Transform.scale(
                  scale: _scaleAnim.value,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: photoExists
                          ? Image.file(
                              File(widget.puzzle.photoPath),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppColors.surfaceDark,
                              child: Icon(
                                Icons.check_circle_outline,
                                size: 80,
                                color: AppColors.gold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Поздравление
                Opacity(
                  opacity: _fadeAnim.value,
                  child: Text(
                    loc.translate('puzzleComplete'),
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.gold,
                      fontFamily: 'Handwritten',
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Opacity(
                  opacity: _fadeAnim.value,
                  child: Text(
                    '${widget.puzzle.totalPieces} ${loc.translate('piecesCount', args: {
                              'count': widget.puzzle.totalPieces.toString()
                            }).replaceAll(widget.puzzle.totalPieces.toString(), '').trim()}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const Spacer(),

                // Кнопки
                Opacity(
                  opacity: _fadeAnim.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _playAgain,
                            icon: const Icon(Icons.replay),
                            label: Text(loc.translate('collectAgain')),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _goHome,
                            icon: const Icon(Icons.home_outlined),
                            label: Text(loc.translate('myPuzzles')),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.gold,
                              side: const BorderSide(color: AppColors.gold),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
