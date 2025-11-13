class AnimeModel {
  final int malId;
  final String title;
  final String? titleEnglish;
  final String imageUrl;
  final double score;
  final String synopsis;
  final String? type;
  final int? episodes;
  final String? rating;
  final String? status;
  final int? year;
  final List<String> genres;
  final String? trailerUrl;

  AnimeModel({
    required this.malId,
    required this.title,
    this.titleEnglish,
    required this.imageUrl,
    required this.score,
    required this.synopsis,
    this.type,
    this.episodes,
    this.rating,
    this.status,
    this.year,
    this.genres = const [],
    this.trailerUrl,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? json['title_english'] ?? 'No Title',
      titleEnglish: json['title_english'],
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      score: (json['score'] is num) ? (json['score'] as num).toDouble() : 0.0,
      synopsis: json['synopsis'] ?? 'Tidak ada sinopsis.',
      type: json['type'],
      episodes: json['episodes'],
      rating: json['rating'],
      status: json['status'],
      year: json['year'],
      genres: (json['genres'] is List)
          ? (json['genres'] as List)
              .map((g) => g['name'].toString())
              .toList()
          : [],
      trailerUrl: json['trailer']?['embed_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mal_id': malId,
      'title': title,
      'title_english': titleEnglish,
      'image_url': imageUrl,
      'score': score,
      'synopsis': synopsis,
      'type': type,
      'episodes': episodes,
      'rating': rating,
      'status': status,
      'year': year,
      'genres': genres.join(', '),
      'trailer_url': trailerUrl,
    };
  }

  factory AnimeModel.fromMap(Map<String, dynamic> map) {
    return AnimeModel(
      malId: (map['mal_id'] is int)
          ? map['mal_id']
          : int.tryParse(map['mal_id'].toString()) ?? 0,
      title: map['title'] ?? '',
      titleEnglish: map['title_english'],
      imageUrl: map['image_url'] ?? '',
      score: (map['score'] is num)
          ? (map['score'] as num).toDouble()
          : double.tryParse(map['score'].toString()) ?? 0.0,
      synopsis: map['synopsis'] ?? '',
      type: map['type'],
      episodes: (map['episodes'] is int)
          ? map['episodes']
          : int.tryParse(map['episodes'].toString()),
      rating: map['rating'],
      status: map['status'],
      year: (map['year'] is int)
          ? map['year']
          : int.tryParse(map['year'].toString()),
      genres: (map['genres'] != null)
          ? map['genres'].toString().split(',').map((e) => e.trim()).toList()
          : [],
      trailerUrl: map['trailer_url'],
    );
  }
}
