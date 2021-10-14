import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_flow_state.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/page_controller/movie_page_controller.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/result/movie.dart';

import 'movie_service.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
        (ref) {
  ref.maintainState = true;
  final movieController = ref.watch(moviePageControllerProvider.notifier);
  final movieService = ref.watch(movieServiceProvider);
  return MovieFlowController(
    MovieFlowState(
      movie: AsyncValue.data(Movie.initial()),
      genres: const AsyncValue.data([]),
      similarMovies: AsyncValue.data([Movie.initial()]),
    ),
    movieController,
    movieService,
  );
});

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(
      MovieFlowState state, this.moviePageController, this._movieService)
      : super(state) {
    loadGenres();
  }
  final MoviePageController moviePageController;
  final MovieService _movieService;

  Future<void> loadGenres() async {
    state = state.copyWith(genres: const AsyncValue.loading());
    final result = await _movieService.getGenres();
    if (mounted) state = state.copyWith(genres: AsyncValue.data(result));
  }

  Future<void> getRecommendedMovie() async {
    state = state.copyWith(movie: const AsyncValue.loading());
    state = state.copyWith(similarMovies: const AsyncValue.loading());
    final selectedGenres = state.genres.asData?.value
            .where((element) => element.isSelected == true)
            .toList(growable: false) ??
        [];
    final result = await _movieService.getRecommendedMovie(
      state.rating,
      state.yearsBack,
      selectedGenres,
    );
    state = state.copyWith(movie: AsyncValue.data(result));
    final similarMovies = await _movieService.getSimilarMovies(
        state.movie.asData!.value, selectedGenres);
    state = state.copyWith(similarMovies: AsyncValue.data(similarMovies));
  }

  void toggleSelected(Genre genre) {
    state = state.copyWith(
      genres: AsyncValue.data([
        for (final oldGenre in state.genres.asData!.value)
          if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre
      ]),
    );
  }

  void updateRating(int updatedRating) {
    state = state.copyWith(rating: updatedRating);
  }

  void updateYearsBack(int updatedYearsBack) {
    state = state.copyWith(yearsBack: updatedYearsBack);
  }

  void nextPage() {
    if (moviePageController.state.pageController.page! >= 1) {
      if (!state.genres.asData!.value
          .any((element) => element.isSelected == true)) {
        return;
      }
    }

    moviePageController.nextPage();
  }

  void previousPage() {
    moviePageController.previousPage();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
