import 'dart:convert';
import 'puzzle_piece.dart';
import 'art_style.dart';

class Puzzle {
  final String id;
  final String photoPath;
  final ArtStyle style;
  final int totalPieces;
  final int completedPieces;
  final DateTime createdAt;
  final bool isCompleted;
  final List<PuzzlePiece> pieces;

  Puzzle({
    required this.id,
    required this.photoPath,
    required this.style,
    required this.totalPieces,
    required this.createdAt,
    this.completedPieces = 0,
    this.isCompleted = false,
    this.pieces = const [],
  });

  // Прогресс в процентах (0.0 - 1.0)
  double get progress => totalPieces > 0 ? completedPieces / totalPieces : 0.0;

  // Создать копию с изменениями
  Puzzle copyWith({
    String? id,
    String? photoPath,
    ArtStyle? style,
    int? totalPieces,
    int? completedPieces,
    DateTime? createdAt,
    bool? isCompleted,
    List<PuzzlePiece>? pieces,
  }) {
    return Puzzle(
      id: id ?? this.id,
      photoPath: photoPath ?? this.photoPath,
      style: style ?? this.style,
      totalPieces: totalPieces ?? this.totalPieces,
      completedPieces: completedPieces ?? this.completedPieces,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      pieces: pieces ?? this.pieces,
    );
  }

  // Сохранить в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photoPath': photoPath,
      'style': style.name,
      'totalPieces': totalPieces,
      'completedPieces': completedPieces,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Загрузить из JSON
  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
      id: json['id'] as String,
      photoPath: json['photoPath'] as String,
      style: ArtStyle.values.firstWhere(
        (s) => s.name == json['style'],
        orElse: () => ArtStyle.aquarel,
      ),
      totalPieces: json['totalPieces'] as int,
      completedPieces: json['completedPieces'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  String toString() =>
      'Puzzle(id: $id, progress: ${(progress * 100).toInt()}%)';
}
