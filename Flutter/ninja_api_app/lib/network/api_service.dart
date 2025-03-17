import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> getRandomQuote() async {
    try {
      final response = await _dio.get('quotes');
      return response.data[0]; // API возвращает массив, берем первый элемент
    } catch (e) {
      throw Exception('Failed to load quote: $e');
    }
  }
}