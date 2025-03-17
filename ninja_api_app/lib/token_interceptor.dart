import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  // Замените на ваш реальный API ключ от api-ninjas.com
  static const String apiKey = 'XETpuHDUC1dI72zlK+5l4g==rVIlI1NO5wGvzfOJ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Api-Key'] = apiKey;
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
    }
    super.onError(err, handler);
  }
}