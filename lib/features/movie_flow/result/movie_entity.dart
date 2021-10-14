import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class MovieEntity {
  final String title;
  final String overview;
  final num voteAverage;
  final num id;
  final List<int> genreIds;
  final String releaseDate;
  final String? backdropPath;
  final String? posterPath;
  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genreIds,
    required this.releaseDate,
    this.backdropPath,
    this.posterPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title': title,
      'overview': overview,
      'vote_average': voteAverage,
      'genre_ids': genreIds,
      'release_date': releaseDate,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
    };
  }

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      title: map['title'],
      id: map['id'],
      overview: map['overview'],
      voteAverage: map['vote_average'],
      genreIds: List<int>.from(map['genre_ids']),
      releaseDate: map['release_date'],
      backdropPath: map['backdrop_path'],
      posterPath: map['poster_path'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieEntity.fromJson(String source) => MovieEntity.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MovieEntity &&
      other.title == title &&
      other.overview == overview &&
      other.voteAverage == voteAverage &&
      listEquals(other.genreIds, genreIds) &&
      other.releaseDate == releaseDate &&
      other.backdropPath == backdropPath &&
      other.id == id &&
      other.posterPath == posterPath;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      overview.hashCode ^
      id.hashCode ^
      voteAverage.hashCode ^
      genreIds.hashCode ^
      releaseDate.hashCode ^
      backdropPath.hashCode ^
      posterPath.hashCode;
  }

  @override
  String toString() {
    return 'MovieEntity(title: $title, overview: $overview, voteAverage: $voteAverage, genreIds: $genreIds, releaseDate: $releaseDate, backdropPath: $backdropPath, posterPath: $posterPath)';
  }
}
