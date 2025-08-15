import 'package:file_selector/file_selector.dart';
import '../utils/base64_image.dart';
import '../utils/pdf_extract.dart';

class FilePickUtil {
  static const List<String> _supportedImageTypes = [
    'png',
    'jpg',
    'jpeg',
    'webp',
    'gif',
    'bmp',
  ];
  static const List<String> _supportedTextTypes = ['txt', 'md', 'pdf'];

  static Future<List<XFile>> pickFiles() async {
    const typeGroup = XTypeGroup(
      label: 'Supported files',
      extensions: [..._supportedImageTypes, ..._supportedTextTypes],
    );

    final files = await openFiles(acceptedTypeGroups: [typeGroup]);
    return files;
  }

  static Future<String> extractTextContent(XFile file) async {
    final fileName = file.name.toLowerCase();
    final bytes = await file.readAsBytes();

    if (PdfExtractUtil.isPdfFile(fileName)) {
      return await PdfExtractUtil.extractText(bytes);
    } else if (fileName.endsWith('.txt') || fileName.endsWith('.md')) {
      return String.fromCharCodes(bytes);
    }

    return '';
  }

  static bool isImageFile(String fileName) {
    return Base64ImageUtil.isImageFile(fileName);
  }

  static bool isTextFile(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return _supportedTextTypes.contains(extension);
  }

  static bool isSupportedFile(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return [
      ..._supportedImageTypes,
      ..._supportedTextTypes,
    ].contains(extension);
  }
}
