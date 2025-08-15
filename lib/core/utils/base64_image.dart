import 'dart:convert';
import 'dart:typed_data';

class Base64ImageUtil {
  static String bytesToDataUrl(Uint8List bytes, String mimeType) {
    final base64String = base64Encode(bytes);
    return 'data:$mimeType;base64,$base64String';
  }

  static String getMimeTypeFromExtension(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/png'; // fallback
    }
  }

  static bool isImageFile(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return ['png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp'].contains(extension);
  }

  static String imageToDataUrl(Uint8List bytes, String fileName) {
    final mimeType = getMimeTypeFromExtension(fileName);
    return bytesToDataUrl(bytes, mimeType);
  }
}
