// Расчёт сетки кусочков по их количеству
class PuzzleDifficulty {
  final int totalPieces;
  final int columns;
  final int rows;

  const PuzzleDifficulty({
    required this.totalPieces,
    required this.columns,
    required this.rows,
  });

  // Рассчитать оптимальную сетку для заданного количества кусочков
  factory PuzzleDifficulty.fromCount(int pieceCount) {
    // Ограничиваем диапазон
    final count = pieceCount.clamp(12, 500);

    // Находим ближайший квадратный корень
    final sqrt = _sqrt(count);

    // Пробуем разные соотношения сторон
    int bestCols = sqrt;
    int bestRows = sqrt;

    // Ищем делители, близкие к квадратному корню
    int bestDiff = (sqrt * sqrt - count).abs();

    for (int cols = 1; cols <= count; cols++) {
      if (count % cols == 0) {
        final rows = count ~/ cols;
        final diff = (cols - rows).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          bestCols = cols;
          bestRows = rows;
        }
      }
    }

    // Если не нашли точный делитель — используем приблизительный
    if (bestCols * bestRows != count) {
      bestCols = sqrt;
      bestRows = count ~/ bestCols;
      if (bestCols * bestRows < count) {
        bestRows++;
      }
    }

    return PuzzleDifficulty(
      totalPieces: count,
      columns: bestCols,
      rows: bestRows,
    );
  }

  // Простой квадратный корень (без math библиотеки)
  static int _sqrt(int n) {
    if (n <= 1) return n;
    int x = n;
    int y = (x + 1) ~/ 2;
    while (y < x) {
      x = y;
      y = (x + n ~/ x) ~/ 2;
    }
    return x;
  }
}
