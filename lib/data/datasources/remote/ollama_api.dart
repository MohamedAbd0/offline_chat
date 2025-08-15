import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/errors.dart';
import '../../../core/utils/ldjson_parser.dart';
import '../../../domain/entities/message.dart';

class OllamaApi {
  final Dio _dio;
  final AppConfig _config;

  OllamaApi({required Dio dio, required AppConfig config})
    : _dio = dio,
      _config = config;

  Stream<String> chatStream({
    required List<Message> history,
    CancelToken? cancelToken,
  }) async* {
    try {
      final messages = _buildMessages(history);

      print('OllamaApi: Sending chat request to ${_config.baseUrl}/api/chat');
      print('OllamaApi: Model: ${_config.fixedModel}');
      print('OllamaApi: Messages count: ${messages.length}');

      final response = await _dio.post(
        '/api/chat',
        data: {
          'model': _config.fixedModel,
          'messages': messages,
          'stream': true,
          'temperature': 0.7,
          'keep_alive': _config.keepAlive,
        },
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: null, // No timeout for streaming
          sendTimeout: const Duration(seconds: 60),
        ),
        cancelToken: cancelToken,
      );

      final stream = response.data.stream as Stream<List<int>>;
      yield* LdJsonParser.parseStream(stream.cast<Uint8List>());
    } on DioException catch (e) {
      print('OllamaApi: DioException - ${e.type}: ${e.message}');
      print('OllamaApi: Response: ${e.response}');
      throw _handleDioError(e);
    } catch (e) {
      print('OllamaApi: Unexpected error: $e');
      rethrow;
    }
  }

  Future<String> chatOnce({
    required List<Message> history,
    CancelToken? cancelToken,
  }) async {
    try {
      final messages = _buildMessages(history);

      final response = await _dio.post(
        '/api/chat',
        data: {
          'model': _config.fixedModel,
          'messages': messages,
          'stream': false,
          'temperature': 0.7,
          'keep_alive': _config.keepAlive,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 60),
        ),
        cancelToken: cancelToken,
      );

      final data = response.data as Map<String, dynamic>;
      final message = data['message'] as Map<String, dynamic>?;
      return message?['content'] as String? ?? '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  List<Map<String, dynamic>> _buildMessages(List<Message> history) {
    final messages = <Map<String, dynamic>>[];

    // Add system message if first message isn't system
    if (history.isEmpty || history.first.role != Role.system) {
      messages.add({
        'role': 'system',
        'content': 'You are a helpful assistant.',
      });
    }

    // Add all history messages
    for (final message in history) {
      messages.add({'role': message.role.name, 'content': message.content});
    }

    return messages;
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException('Request timeout');

      case DioExceptionType.connectionError:
        if (e.message?.contains('Connection refused') == true) {
          return const ConnectionRefusedException();
        }
        return NetworkException('Connection error: ${e.message}');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 412 || statusCode == 426) {
          return const OllamaVersionException();
        }
        return OllamaException(
          'HTTP $statusCode: ${e.response?.statusMessage ?? 'Unknown error'}',
          code: statusCode?.toString(),
        );

      case DioExceptionType.cancel:
        return const StreamingCancelledException();

      default:
        return OllamaException('Unexpected error: ${e.message}');
    }
  }
}
