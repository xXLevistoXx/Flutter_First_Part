import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:ninja_api_app/token_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'network/api_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Настройка Dio
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.api-ninjas.com/v1/',
    connectTimeout: Duration(seconds: 10),
  ));

  // Добавляем interceptors
  dio.interceptors.add(TokenInterceptor());
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
  ));

  getIt.registerLazySingleton(() => dio);
  getIt.registerLazySingleton(() => ApiService(getIt<Dio>()));
}