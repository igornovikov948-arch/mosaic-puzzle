import 'dart:io';
import 'package:image/image.dart' as img;
import '../models/art_style.dart';

class StyleTransfer {
  // Применить стиль к фото (заглушка — программные фильтры)
  static Future<File> applyStyle(File photo, ArtStyle style) async {
    final bytes = await photo.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Не удалось загрузить изображение');
    }

    // Обрезать до квадрата
    final size = image.width < image.height ? image.width : image.height;
    image = img.copyCrop(image, x: 0, y: 0, width: size, height: size);

    // Применить фильтр в зависимости от стиля
    switch (style) {
      case ArtStyle.aquarel:
        image = _applyWatercolor(image);
        break;
      case ArtStyle.oil:
        image = _applyOilPainting(image);
        break;
      case ArtStyle.pixel:
        image = _applyPixelArt(image);
        break;
      case ArtStyle.engraving:
        image = _applyEngraving(image);
        break;
    }

    // Сохранить результат
    final dir = photo.parent.path;
    final styledPath =
        '$dir/styled_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final styledFile = File(styledPath);
    await styledFile.writeAsBytes(img.encodeJpg(image, quality: 90));

    return styledFile;
  }

  // Акварель — размытие + усиление контраста
  static img.Image _applyWatercolor(img.Image image) {
    image = img.gaussianBlur(image, radius: 3);
    image = img.adjustColor(image, contrast: 1.2, saturation: 1.1);
    return image;
  }

  // Масло — медианный фильтр + насыщенность
  static img.Image _applyOilPainting(img.Image image) {
    image = img.adjustColor(image, saturation: 1.3, contrast: 1.1);
    return image;
  }

  // Пиксель-арт — уменьшение и увеличение
  static img.Image _applyPixelArt(img.Image image) {
    final small = img.copyResize(image, width: 64);
    image = img.copyResize(small,
        width: 512, interpolation: img.Interpolation.nearest);
    return image;
  }

  // Гравюра — ч/б + резкость
  static img.Image _applyEngraving(img.Image image) {
    image = img.grayscale(image);
    image = img.adjustColor(image, contrast: 1.5);
    return image;
  }
}
