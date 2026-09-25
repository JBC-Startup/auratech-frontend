import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Compresses images to ensure they are under 1 MiB (RNF10)
class ImageCompressor {
  static const int _maxBytes = 1024 * 1024; // 1 MiB

  static Future<File> compress(File file) async {
    final bytes = await file.length();
    if (bytes <= _maxBytes) return file;

    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    int quality = 85;
    File? result;

    while (quality > 10) {
      final xFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 1920,
        minHeight: 1920,
      );

      if (xFile != null) {
        result = File(xFile.path);
        final resultBytes = await result.length();
        if (resultBytes <= _maxBytes) return result;
      }

      quality -= 10;
    }

    return result ?? file;
  }
}
