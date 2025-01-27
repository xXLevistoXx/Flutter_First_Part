import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    // Используем MultiProvider с lazy: false для инициализации провайдера
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NoteProvider(),
          lazy: false, // инициализация провайдера
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Навигация через onGenerateRoute
      onGenerateRoute: (settings) {
        if (settings.name == '/note-detail') {
          return MaterialPageRoute(
            builder: (context) {
              final args = settings.arguments as Map<String, dynamic>;
              return NoteDetail(
                noteIndex: args['index'],
                noteText: args['note'],
              );
            },
          );
        }
        return MaterialPageRoute(builder: (context) => const NoteList());
      },
      home: FutureBuilder(
        // Загрузочное окно при запуске
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return const NoteList();
          }
        },
      ),
    );
  }
}

// Провайдер для управления состоянием заметок
class NoteProvider with ChangeNotifier {
  List<String> _notes = [];
  late SharedPreferences _prefs;

  List<String> get notes => _notes;

  NoteProvider() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _prefs = await SharedPreferences.getInstance();
    _notes = _prefs.getStringList('notes') ?? [];
    notifyListeners(); // Уведомляем слушателей об изменении данных
  }

  Future<void> _saveNotes() async {
    await _prefs.setStringList('notes', _notes);
  }

  void addNote(String note) {
    _notes.add(note);
    _saveNotes();
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    _saveNotes();
    notifyListeners();
  }

  void editNote(int index, String newNote) {
    _notes[index] = newNote;
    _saveNotes();
    notifyListeners();
  }
}

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
      ),
      body: Column(
        children: [
          Expanded(
            // Используем  ListView 
            child: ListView.builder(
              itemCount: noteProvider.notes.length,
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    title: Text(note),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Переход на экран редактирования заметки
                            Navigator.pushNamed(
                              context,
                              '/note-detail',
                              arguments: {'index': index, 'note': note},
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => noteProvider.deleteNote(index),
                        ),
                      ],
                    ),
                    // Добавляем onTap для перехода на экран редактирования
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/note-detail',
                        arguments: {'index': index, 'note': note},
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // FloatingActionButton для добавления новых заметок
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/note-detail',
            arguments: {'index': -1, 'note': ''},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
// Экран деталей заметки
class NoteDetail extends StatefulWidget {
  final int noteIndex;
  final String noteText;

  const NoteDetail({super.key, required this.noteIndex, required this.noteText});

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.noteText);
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteIndex == -1 ? 'Новая заметка' : 'Редактировать заметку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Введите текст',
            border: InputBorder.none,
          ),
          maxLines: null,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_textController.text.isNotEmpty) {
            if (widget.noteIndex == -1) {
              noteProvider.addNote(_textController.text);
            } else {
              noteProvider.editNote(widget.noteIndex, _textController.text);
            }
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}