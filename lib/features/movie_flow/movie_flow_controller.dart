import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_flow_state.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/page_controller/movie_page_controller.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
        (ref) {
  final movieController = ref.read(moviePageControllerProvider.notifier);
  return MovieFlowController(
    MovieFlowState(
      pageController: PageController(),
    ),
    movieController,
  );
});

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(MovieFlowState state, this.moviePageController)
      : super(state);
  final MoviePageController moviePageController;
  void toggleSelected(Genre genre) {
    state = state.copyWith(
      genres: [
        for (final oldGenre in state.genres)
          if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre
      ],
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
      if (!state.genres.any((element) => element.isSelected == true)) {
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
    state.pageController.dispose();
    super.dispose();
  }
}
