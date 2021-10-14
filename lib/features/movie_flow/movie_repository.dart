import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app_course/core/enviroment_variables.dart';

import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre_entity.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/result/movie_entity.dart';
import 'package:movie_recommendation_app_course/main.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TMDBMovieRepository(dio: dio);
});

abstract class MovieRepository {
  Future<List<GenreEntity>> getMovieGenres();
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String date, String genresIds);
  Future<List<MovieEntity>> getSimilarMovies(int movieId);
}

class TMDBMovieRepository implements MovieRepository {
  final Dio dio;
  TMDBMovieRepository({
    required this.dio,
  });

  @override
  Future<List<GenreEntity>> getMovieGenres() async {
    final response = await dio.get('genre/movie/list', queryParameters: {
      'api_key': api,
      'language': 'en-US',
    });

    final results = List<Map<String, dynamic>>.from(response.data['genres']);
    final genres = results.map((e) => GenreEntity.fromMap(e)).toList();
    return genres;
  }

  @override
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String date, String genresIds) async {
    final response = await dio.get('discover/movie', queryParameters: {
      'api_key': api,
      'language': 'en-US',
      'sort-by': 'popularity.desc',
      'include_adult': false,
      'vote_average.gte': rating,
      'page': 1,
      'release_date.gte': date,
    });
    final results = List<Map<String, dynamic>>.from(response.data['results']);
    final movies = results.map((e) => MovieEntity.fromMap(e)).toList();
    return movies;
  }

  @override
  Future<List<MovieEntity>> getSimilarMovies(int movieId) async {
    final response = await dio.get('movie/$movieId/similar', queryParameters: {
      'api_key': api,
    });
    final results = List<Map<String, dynamic>>.from(response.data['results']);
    final movies = results.map((e) => MovieEntity.fromMap(e)).toList();
    return movies;
  }
}
