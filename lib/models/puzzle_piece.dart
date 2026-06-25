import 'dart:ui';

// Форма стороны кусочка
enum SideType {
  flat, // ровный край
  tab, // выступ
  hole, // выемка
}

class PuzzlePiece {
  final int id;
  final int correctRow;
  final int correctCol;
  final double correctX;
  final double correctY;
  double currentX;
  double currentY;
  bool isPlaced;

  // Форма кусочка по 4 сторонам: top, right, bottom, left
  final List<SideType> sides;

  PuzzlePiece({
    required this.id,
    required this.correctRow,
    required this.correctCol,
    required this.correctX,
    required this.correctY,
    required this.currentX,
    required this.currentY,
    required this.sides,
    this.isPlaced = false,
  });

  // Проверить, находится ли кусочек в правильной позиции
  bool isNearCorrectPosition(double threshold) {
    final dx = (currentX - correctX).abs();
    final dy = (currentY - correctY).abs();
    return dx < threshold && dy < threshold;
  }

  // Примагнитить к правильной позиции
  void snapToCorrect() {
    currentX = correctX;
    currentY = correctY;
    isPlaced = true;
  }

  // Сохранить в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correctRow': correctRow,
      'correctCol': correctCol,
      'correctX': correctX,
      'correctY': correctY,
      'currentX': currentX,
      'currentY': currentY,
      'isPlaced': isPlaced,
    };
  }

  // Загрузить из JSON
  factory PuzzlePiece.fromJson(
      Map<String, dynamic> json, List<SideType> sides) {
    return PuzzlePiece(
      id: json['id'] as int,
      correctRow: json['correctRow'] as int,
      correctCol: json['correctCol'] as int,
      correctX: (json['correctX'] as num).toDouble(),
      correctY: (json['correctY'] as num).toDouble(),
      currentX: (json['currentX'] as num).toDouble(),
      currentY: (json['currentY'] as num).toDouble(),
      sides: sides,
      isPlaced: json['isPlaced'] as bool? ?? false,
    );
  }

  @override
  String toString() =>
      'Piece($id, row: $correctRow, col: $correctCol, placed: $isPlaced)';
}
