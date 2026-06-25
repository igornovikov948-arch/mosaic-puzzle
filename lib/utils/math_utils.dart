import 'dart:math';
import '../models/puzzle_piece.dart';

class MathUtils {
  static final Random _random = Random();

  // Случайная позиция на краю доски
  static double randomEdgePosition(double boardSize, double pieceSize) {
    final margin = pieceSize;
    final edge = _random.nextBool();

    if (edge) {
      // Левый или правый край
      final x = _random.nextBool() ? margin : boardSize - margin;
      return x + (_random.nextDouble() - 0.5) * pieceSize;
    } else {
      // Равномерно по всей ширине с отступом
      return margin + _random.nextDouble() * (boardSize - 2 * margin);
    }
  }

  // Сгенерировать форму сторон кусочка
  static List<SideType> generateSides(
      int row, int col, int totalRows, int totalCols) {
    return [
      row == 0
          ? SideType.flat
          : (_random.nextBool() ? SideType.tab : SideType.hole),
      col == totalCols - 1
          ? SideType.flat
          : (_random.nextBool() ? SideType.tab : SideType.hole),
      row == totalRows - 1
          ? SideType.flat
          : (_random.nextBool() ? SideType.tab : SideType.hole),
      col == 0
          ? SideType.flat
          : (_random.nextBool() ? SideType.tab : SideType.hole),
    ];
  }

  // Проверить, можно ли состыковать два кусочка
  static bool canConnect(PuzzlePiece a, PuzzlePiece b) {
    // Сосед по горизонтали
    if (a.correctRow == b.correctRow) {
      if (a.correctCol + 1 == b.correctCol) {
        return a.sides[1] == SideType.tab && b.sides[3] == SideType.hole ||
            a.sides[1] == SideType.hole && b.sides[3] == SideType.tab;
      }
      if (b.correctCol + 1 == a.correctCol) {
        return b.sides[1] == SideType.tab && a.sides[3] == SideType.hole ||
            b.sides[1] == SideType.hole && a.sides[3] == SideType.tab;
      }
    }

    // Сосед по вертикали
    if (a.correctCol == b.correctCol) {
      if (a.correctRow + 1 == b.correctRow) {
        return a.sides[2] == SideType.tab && b.sides[0] == SideType.hole ||
            a.sides[2] == SideType.hole && b.sides[0] == SideType.tab;
      }
      if (b.correctRow + 1 == a.correctRow) {
        return b.sides[2] == SideType.tab && a.sides[0] == SideType.hole ||
            b.sides[2] == SideType.hole && a.sides[0] == SideType.tab;
      }
    }

    return false;
  }
}
