import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class WatermarkUtil {
  WatermarkUtil._();

  static Future<File> applyWatermark({
    required File imageFile,
    String text = 'Captured by MyApp',
    double lat = 0,
    double lng = 0,
    String? address,
  }) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? src = img.decodeImage(bytes);
    if (src == null) throw Exception('Cannot decode image');

    if (src.width > 2048) {
      src = img.copyResize(src, width: 2048);
    }

    final w = src.width;
    final h = src.height;

    final stripH = (h * 0.20).toInt().clamp(120, 200);
    for (var y = h - stripH; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final px = src.getPixel(x, y);
        const factor = 0.25;
        src.setPixel(
          x,
          y,
          img.ColorRgba8(
            (px.r * factor).toInt(),
            (px.g * factor).toInt(),
            (px.b * factor).toInt(),
            255,
          ),
        );
      }
    }

    img.drawString(
      src,
      text,
      font: img.arial48,
      x: 20,
      y: h - stripH + 16,
      color: img.ColorRgba8(255, 255, 255, 240),
    );

    final coordText =
        'GPS: ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
    final coordW = coordText.length * 14;
    img.drawString(
      src,
      coordText,
      font: img.arial24,
      x: (w - coordW).clamp(20, w - 20),
      y: h - stripH + 20,
      color: img.ColorRgba8(180, 210, 255, 230),
    );

    if (address != null && address.isNotEmpty) {
      final displayAddr = address.length > 55
          ? '${address.substring(0, 52)}...'
          : address;
      img.drawString(
        src,
        displayAddr,
        font: img.arial24,
        x: 20,
        y: h - stripH + 68,
        color: img.ColorRgba8(200, 255, 200, 220),
      );
    }

    img.drawString(
      src,
      DateTime.now().toLocal().toString().split('.').first,
      font: img.arial48,
      x: w ~/ 2 - 200,
      y: h ~/ 2 - 24,
      color: img.ColorRgba8(0, 0, 0, 255),
    );

    final dir = await getTemporaryDirectory();
    final outPath = p.join(
      dir.path,
      'wm_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final out = File(outPath);
    await out.writeAsBytes(img.encodeJpg(src, quality: 90));
    return out;
  }
}
