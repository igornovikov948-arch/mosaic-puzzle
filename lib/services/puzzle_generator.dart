import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/puzzle.dart';
import '../models/puzzle_difficulty.dart';
import '../models/art_style.dart';
import 'style_transfer.dart';
import 'image_processor.dart';
import 'puzzle_storage.dart';

class PuzzleGenerator {
  static const double boardSize = 800.0; // Размер игрового поля
  static const _uuid = Uuid();

  // Создать новый пазл из фото
  static Future<Puzzle> generate({
    required File photo,
    required ArtStyle style,
    required int pieceCount,
  }) async {
    // 1. Применить стиль
    final styledPhoto = await StyleTransfer.applyStyle(photo, style);

    // 2. Загрузить и сжать изображение
    final image = await ImageProcessor.loadAndResize(styledPhoto);

    // 3. Рассчитать сетку
    final difficulty = PuzzleDifficulty.fromCount(pieceCount);

    // 4. Нарезать на кусочки
    final pieces = ImageProcessor.sliceIntoPieces(
      image: image,
      difficulty: difficulty,
      boardWidth: boardSize,
      boardHeight: boardSize,
    );

    // 5. Сохранить стилизованное фото
    final dir = (await _getPuzzleDirectory()).path;
    final savedPhoto = await ImageProcessor.saveImage(
      image,
      '$dir/puzzle_${_uuid.v4()}.jpg',
    );

    // 6. Создать модель пазла
    final puzzle = Puzzle(
      id: _uuid.v4(),
      photoPath: savedPhoto.path,
      style: style,
      totalPieces: pieceCount,
      createdAt: DateTime.now(),
      pieces: pieces,
    );

    // 7. Сохранить в хранилище
    await PuzzleStorage.addPuzzle(puzzle);

    return puzzle;
  }

  // Получить папку для хранения пазлов
  static Future<Directory> _getPuzzleDirectory() async {
    final dir = Directory('${(await _getBaseDirectory()).path}/puzzles');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Directory> _getBaseDirectory() async {
    return Directory('${Directory.systemTemp.path}/mosaic_app');
  }
}
