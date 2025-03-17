import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/database_helper.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie? movie;
  const MovieDetailScreen({this.movie, super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late TextEditingController _genreController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _yearController = TextEditingController(text: widget.movie?.year.toString() ?? '');
    _genreController = TextEditingController(text: widget.movie?.genre ?? '');
    _imagePath = widget.movie?.imagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      final movie = Movie(
        id: widget.movie?.id,
        title: _titleController.text,
        year: int.parse(_yearController.text),
        genre: _genreController.text,
        imagePath: _imagePath,
      );

      if (widget.movie == null) {
        await dbHelper.insertMovie(movie);
      } else {
        await dbHelper.updateMovie(movie);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Определяем, является ли текущая тема тёмной
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Новый фильм' : 'Редактировать фильм'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_imagePath != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_imagePath!),
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Выбрать изображение'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Название',
                  labelStyle: TextStyle(
                    color: isDarkTheme ? Colors.white70 : Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
                validator: (value) => value!.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Год',
                  labelStyle: TextStyle(
                    color: isDarkTheme ? Colors.white70 : Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Введите год' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Жанр',
                  labelStyle: TextStyle(
                    color: isDarkTheme ? Colors.white70 : Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
                validator: (value) => value!.isEmpty ? 'Введите жанр' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMovie,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    super.dispose();
  }
}