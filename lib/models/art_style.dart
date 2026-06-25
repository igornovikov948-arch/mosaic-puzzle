// Стили для обработки фото
enum ArtStyle {
  aquarel, // Акварель
  oil, // Масло
  pixel, // Пиксель-арт
  engraving, // Гравюра
}

// Расширение для получения названий и описаний
extension ArtStyleX on ArtStyle {
  // Ключ для перевода
  String get translationKey {
    switch (this) {
      case ArtStyle.aquarel:
        return 'styleAquarel';
      case ArtStyle.oil:
        return 'styleOil';
      case ArtStyle.pixel:
        return 'stylePixel';
      case ArtStyle.engraving:
        return 'styleEngraving';
    }
  }

  // Название для отладки
  String get displayName {
    switch (this) {
      case ArtStyle.aquarel:
        return 'Акварель';
      case ArtStyle.oil:
        return 'Масло';
      case ArtStyle.pixel:
        return 'Пиксель-арт';
      case ArtStyle.engraving:
        return 'Гравюра';
    }
  }
}
