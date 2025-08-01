import 'package:dio/dio.dart';
import 'package:shop/utils/dio_client/app_interceptors.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static DioClient? _singleton;

  static late Dio _dio;

  DioClient._() {
    _dio = createDioClient();
  }

  factory DioClient() {
    return _singleton ??= DioClient._();
  }

  Dio get instance => _dio;
  String get baseUrl => _dio.options.baseUrl; // Expose the base URL

  Dio createDioClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2",
        // baseUrl: "http://192.168.0.107",
//php artisan serve --host=0.0.0.0 --port=8000
//done done done
        receiveTimeout: 30000, // 30 seconds
        connectTimeout: 30000,
        sendTimeout: 30000,
        headers: {
          Headers.acceptHeader: 'application/json',
          Headers.contentTypeHeader: 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
      AppInterceptors(),
    ]);

    return dio;
  }
  
} 