import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'network/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _apiService = GetIt.I<ApiService>();
  String _quote = '';
  String _author = '';
  bool _isLoading = false;

  Future<void> _fetchQuote() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getRandomQuote();
      setState(() {
        _quote = result['quote'] ?? 'No quote available';
        _author = result['author'] ?? 'Unknown';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Генератор Рандомных Цитат'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              color: const Color(0xFFDEBA9D),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _quote,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1A2B47),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- $_author',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF1A2B47),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _fetchQuote,
                    child: const Text('Получить Новую Цитату'),
                  ),
          ],
        ),
      ),
    );
  }
}