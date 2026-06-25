import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../models/art_style.dart';
import '../services/puzzle_generator.dart';
import '../utils/constants.dart';
import '../widgets/style_selector.dart';
import '../widgets/difficulty_slider.dart';
import 'puzzle_game_screen.dart';

enum CreationStep { photo, style, difficulty, processing }

class CreatePuzzleScreen extends StatefulWidget {
  const CreatePuzzleScreen({super.key});

  @override
  State<CreatePuzzleScreen> createState() => _CreatePuzzleScreenState();
}

class _CreatePuzzleScreenState extends State<CreatePuzzleScreen> {
  final ImagePicker _picker = ImagePicker();

  CreationStep _step = CreationStep.photo;
  File? _selectedPhoto;
  ArtStyle _selectedStyle = ArtStyle.aquarel;
  int _pieceCount = AppSizes.defaultPieces;

  void _pickPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (image != null) {
      setState(() {
        _selectedPhoto = File(image.path);
        _step = CreationStep.style;
      });
    }
  }

  void _selectStyle(ArtStyle style) {
    setState(() {
      _selectedStyle = style;
      _step = CreationStep.difficulty;
    });
  }

  void _startProcessing() async {
    if (_selectedPhoto == null) return;

    setState(() => _step = CreationStep.processing);

    try {
      final puzzle = await PuzzleGenerator.generate(
        photo: _selectedPhoto!,
        style: _selectedStyle,
        pieceCount: _pieceCount,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PuzzleGameScreen(puzzle: puzzle),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
        setState(() => _step = CreationStep.difficulty);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(loc.translate('createPuzzle')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildStepContent(loc),
    );
  }

  Widget _buildStepContent(AppLocalizations loc) {
    switch (_step) {
      case CreationStep.photo:
        return _buildPhotoStep(loc);
      case CreationStep.style:
        return _buildStyleStep(loc);
      case CreationStep.difficulty:
        return _buildDifficultyStep(loc);
      case CreationStep.processing:
        return _buildProcessingStep(loc);
    }
  }

  Widget _buildPhotoStep(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 80, color: AppColors.gold),
            const SizedBox(height: 24),
            Text(
              loc.translate('selectPhoto'),
              style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.image),
              label: Text(loc.translate('selectPhoto')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleStep(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            loc.translate('selectStyle'),
            style: TextStyle(fontSize: 22, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          StyleSelector(
            selectedStyle: _selectedStyle,
            onStyleSelected: _selectStyle,
          ),
          const SizedBox(height: 32),
          if (_selectedPhoto != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedPhoto!,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDifficultyStep(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            loc.translate('difficulty'),
            style: TextStyle(fontSize: 22, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 40),
          DifficultySlider(
            value: _pieceCount,
            onChanged: (value) => setState(() => _pieceCount = value),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _startProcessing,
            icon: const Icon(Icons.auto_awesome),
            label: Text(loc.translate('startPuzzle')),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProcessingStep(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.gold),
          const SizedBox(height: 24),
          Text(
            loc.translate('processing'),
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
