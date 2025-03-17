import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';
import 'settings_screen.dart';

class MovieListScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDark;
  const MovieListScreen({required this.toggleTheme, required this.isDark, super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final movieList = await dbHelper.getMovies();
    setState(() {
      movies = movieList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои фильмы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(
                  toggleTheme: widget.toggleTheme,
                  isDark: widget.isDark,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(movie.title),
              subtitle: Text('${movie.year} • ${movie.genre}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await dbHelper.deleteMovie(movie.id!);
                  _loadMovies();
                },
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movie),
                ),
              ).then((_) => _loadMovies()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: null),
          ),
        ).then((_) => _loadMovies()),
      ),
    );
  }
}