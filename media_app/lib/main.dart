import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';
import 'package:audioplayers/audioplayers.dart';

// https://bringsluck.ru/music/Sergey%20Melnikov%20-%20Vspomni%20oseny.mp3

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media App',
      theme: ThemeData(
        primaryColor: const Color(0xFFD8C4A6), // бежевый
        scaffoldBackgroundColor: const Color(0xFFF5E8D3), // светло-бежевый
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD8C4A6),
          secondary: Color(0xFF78866B), // хаки
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF78866B),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    GalleryScreen(),
    MusicScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Галерея',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Музыка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF78866B),
        onTap: _onItemTapped,
      ),
    );
  }
}

// Экран галереи
// Экран галереи
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<File> _mediaFiles = [];

  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    final picker = ImagePicker();
    final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _mediaFiles.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Галерея'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () => _pickMedia(ImageSource.gallery, false),
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _pickMedia(ImageSource.gallery, true),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _mediaFiles.length,
        itemBuilder: (context, index) {
          final file = _mediaFiles[index];
          return GestureDetector(
            onTap: () {
              if (file.path.endsWith('.mp4')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoFile: file),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewScreen(imageFile: file),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              width: double.infinity, // Занимает всю доступную ширину
              child: file.path.endsWith('.mp4')
                  ? VideoThumbnail(file: file)
                  : AspectRatio(
                      aspectRatio: 1.0, // Начальное соотношение сторон
                      child: Image.file(
                        file,
                        fit: BoxFit.contain, // Изображение полностью видно
                        width: double.infinity,
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

// Миниатюра видео
class VideoThumbnail extends StatefulWidget {
  final File file;
  const VideoThumbnail({super.key, required this.file});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

// Экран воспроизведения видео
class VideoPlayerScreen extends StatefulWidget {
  final File videoFile;
  const VideoPlayerScreen({super.key, required this.videoFile});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Видео')),
      body: _controller.value.isInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                VideoProgressIndicator(_controller, allowScrubbing: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// Экран просмотра фото
class PhotoViewScreen extends StatelessWidget {
  final File imageFile;
  const PhotoViewScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фото')),
      body: PhotoView(imageProvider: FileImage(imageFile)),
    );
  }
}

// Экран музыки
// Экран музыки
class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _audioUrls = [];
  String? _currentUrl;
  final TextEditingController _urlController = TextEditingController();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    
    // Подписываемся на изменения позиции
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

    // Подписываемся на изменения длительности
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _addAudioUrl() {
    if (_urlController.text.isNotEmpty) {
      setState(() {
        _audioUrls.add(_urlController.text);
        _urlController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Музыка')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Вставьте URL аудио',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addAudioUrl,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _audioUrls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Аудио ${index + 1}'),
                  onTap: () async {
                    if (_currentUrl != _audioUrls[index]) {
                      await _audioPlayer.stop();
                      await _audioPlayer.play(UrlSource(_audioUrls[index]));
                      setState(() {
                        _currentUrl = _audioUrls[index];
                      });
                    }
                  },
                );
              },
            ),
          ),
          if (_currentUrl != null)
            Column(
              children: [
                Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    final newPosition = Duration(seconds: value.toInt());
                    _audioPlayer.seek(newPosition);
                    setState(() {
                      _position = newPosition;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position)),
                      Text(_formatDuration(_duration)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () => _audioPlayer.resume(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: () => _audioPlayer.pause(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () => _audioPlayer.stop(),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}