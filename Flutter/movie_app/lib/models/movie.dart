class Movie {
  int? id;
  String title;
  int year;
  String genre;
  String? imagePath;

  Movie({
    this.id,
    required this.title,
    required this.year,
    required this.genre,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'genre': genre,
      'imagePath': imagePath,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      year: map['year'],
      genre: map['genre'],
      imagePath: map['imagePath'],
    );
  }
}