import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../models/puzzle_piece.dart';
import '../models/puzzle_difficulty.dart';
import '../utils/math_utils.dart';

class ImageProcessor {
  // Загрузить и сжать изображение
  static Future<img.Image> loadAndResize(File photoFile,
      {int maxSize = 1024}) async {
    final bytes = await photoFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Не удалось загрузить изображение');
    }

    // Обрезать до квадрата
    image = img.copyCrop(image,
        x: 0, y: 0, width: image.width, height: image.width);

    // Уменьшить, если больше maxSize
    if (image.width > maxSize) {
      image = img.copyResize(image, width: maxSize, height: maxSize);
    }

    return image;
  }

  // Нарезать изображение на кусочки
  static List<PuzzlePiece> sliceIntoPieces({
    required img.Image image,
    required PuzzleDifficulty difficulty,
    required double boardWidth,
    required double boardHeight,
  }) {
    final pieces = <PuzzlePiece>[];
    final cols = difficulty.columns;
    final rows = difficulty.rows;
    final pieceWidth = boardWidth / cols;
    final pieceHeight = boardHeight / rows;

    int id = 0;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Правильная позиция на доске
        final correctX = col * pieceWidth + pieceWidth / 2;
        final correctY = row * pieceHeight + pieceHeight / 2;

        // Случайная начальная позиция (по краям доски)
        final startX = MathUtils.randomEdgePosition(boardWidth, pieceWidth);
        final startY = MathUtils.randomEdgePosition(boardHeight, pieceHeight);

        // Определяем форму сторон
        final sides = MathUtils.generateSides(row, col, rows, cols);

        pieces.add(PuzzlePiece(
          id: id,
          correctRow: row,
          correctCol: col,
          correctX: correctX,
          correctY: correctY,
          currentX: startX,
          currentY: startY,
          sides: sides,
        ));

        id++;
      }
    }

    return pieces;
  }

  // Конвертировать img.Image в файл
  static Future<File> saveImage(img.Image image, String path) async {
    final file = File(path);
    final bytes = img.encodeJpg(image, quality: 90);
    await file.writeAsBytes(bytes);
    return file;
  }
}
