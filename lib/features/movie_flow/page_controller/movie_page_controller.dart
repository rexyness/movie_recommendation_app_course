import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/page_controller/movie_page_state.dart';

final moviePageControllerProvider = StateNotifierProvider
    .autoDispose<MoviePageController, MoviePageState>((ref) =>
        MoviePageController(MoviePageState(pageController: PageController())));

class MoviePageController extends StateNotifier<MoviePageState> {
  MoviePageController(MoviePageState state) : super(state);
  void nextPage() {
    state.pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void previousPage() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}
