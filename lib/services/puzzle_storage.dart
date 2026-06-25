import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/puzzle.dart';
import '../utils/constants.dart';

class PuzzleStorage {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/${AppStorageKeys.puzzlesList}');
  }

  // Сохранить список пазлов
  static Future<void> saveAll(List<Puzzle> puzzles) async {
    final file = await _getFile();
    final jsonList = puzzles.map((p) => p.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  // Загрузить все пазлы
  static Future<List<Puzzle>> loadAll() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      final jsonList = json.decode(content) as List<dynamic>;
      return jsonList
          .map((j) => Puzzle.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Добавить новый пазл
  static Future<void> addPuzzle(Puzzle puzzle) async {
    final puzzles = await loadAll();
    puzzles.insert(0, puzzle);
    await saveAll(puzzles);
  }

  // Обновить пазл
  static Future<void> updatePuzzle(Puzzle updated) async {
    final puzzles = await loadAll();
    final index = puzzles.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      puzzles[index] = updated;
      await saveAll(puzzles);
    }
  }

  // Удалить пазл
  static Future<void> deletePuzzle(String id) async {
    final puzzles = await loadAll();
    puzzles.removeWhere((p) => p.id == id);
    await saveAll(puzzles);
  }
}
