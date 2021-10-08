import 'package:flutter/widgets.dart';

@immutable
class MoviePageState {
  final PageController pageController;
  const MoviePageState({
    required this.pageController,
  });

  MoviePageState copyWith({
    PageController? pageController,
  }) {
    return MoviePageState(
      pageController: pageController ?? this.pageController,
    );
  }

  @override
  String toString() => 'MoivePageControllerState(pageController: $pageController)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MoviePageState &&
      other.pageController == pageController;
  }

  @override
  int get hashCode => pageController.hashCode;
}
