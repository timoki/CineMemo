import 'package:cine_memo/core/api_constants.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..interceptors.add(LogInterceptor()) // 개발 중 로그 확인용
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // 모든 요청 헤더에 인증 토큰 추가
            options.headers['Authorization'] = 'Bearer ${ApiConstants.apiKey}';
            return handler.next(options);
          },
        ),
      );
  }

  // GET 요청 예시
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // 에러 처리 로직 (나중에 추가)
      throw Exception(e.message);
    }
  }
}
