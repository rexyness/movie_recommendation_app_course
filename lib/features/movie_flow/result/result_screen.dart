import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app_course/core/constants.dart';
import 'package:movie_recommendation_app_course/core/failure.dart';
import 'package:movie_recommendation_app_course/core/widgets/failure_screen.dart';
import 'package:movie_recommendation_app_course/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_flow_controller.dart';

import 'package:movie_recommendation_app_course/features/movie_flow/result/movie.dart';
import 'package:movie_recommendation_app_course/responsive.dart';

class ResultScreen extends ConsumerWidget {
  static route({bool fullscreenDialog = true}) => MaterialPageRoute(
        builder: (context) => const ResultScreen(),
        fullscreenDialog: fullscreenDialog,
      );
  const ResultScreen({Key? key}) : super(key: key);

  final double movieHeight = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ref.watch(movieFlowControllerProvider).movie.when(
          data: (movie) {
            if (Responsive.isDesktop(context)) {
              return Scaffold(
                appBar: AppBar(
                  title: Responsive.isDesktop(context)
                      ? Center(
                          child: Text(movie.title,
                              textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline5),
                        )
                      : const Text(""),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(flex:2,child: Image.network(movie.backdropPath ?? '', height: 700, width: 500, fit: BoxFit.fitHeight)),
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 1,
                              child: SizedBox(
                                
                                
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: theme.textTheme.headline6,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      movie.genresCommaSeparated,
                                      style: theme.textTheme.bodyText2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          movie.voteAverage.toString(),
                                          style: theme.textTheme.bodyText2?.copyWith(
                                            color: theme.textTheme.bodyText2?.color?.withOpacity(0.62),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.star_rounded,
                                          size: 20,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        movie.overview,
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: kMediumSpacing,
                      ),
                      PrimaryButton(
                        onPressed: () => Navigator.of(context).pop(),
                        text: 'Find another movie',
                      ),
                    ],
                  ),
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CoverImage(
                              movie: movie,
                            ),
                            Positioned(
                              width: MediaQuery.of(context).size.width,
                              bottom: -(movieHeight / 2),
                              child: MovieImageDetails(
                                movie: movie,
                                movieHeight: movieHeight,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: movieHeight / 2),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            movie.overview,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            ref
                                .watch(movieFlowControllerProvider)
                                .similarMovies
                                .asData!
                                .value
                                .map((e) => e.title)
                                .toList()
                                .join(' , '),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'Find another movie',
                  ),
                  const SizedBox(height: kMediumSpacing),
                ],
              ),
            );
          },
          error: (e, s, data) {
            if (e is Failure) return FailureScreen(message: e.message);
            return const FailureScreen(message: 'Something went wrong');
          },
          loading: (_) => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 298),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: FittedBox(
          clipBehavior: Clip.antiAlias,
          fit: BoxFit.fitHeight,
          child: Image.network(
            movie.backdropPath ?? '',
            fit: BoxFit.fitWidth,
            errorBuilder: (context, e, s) {
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class MovieImageDetails extends ConsumerWidget {
  const MovieImageDetails({
    Key? key,
    required this.movie,
    required this.movieHeight,
  }) : super(key: key);

  final Movie movie;

  final double movieHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: movieHeight,
            child: Image.network(
              movie.posterPath ?? '',
              fit: Responsive.isDesktop(context) ? BoxFit.fitWidth : BoxFit.cover,
              errorBuilder: (context, e, s) {
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: theme.textTheme.headline6,
                ),
                Text(
                  movie.genresCommaSeparated,
                  style: theme.textTheme.bodyText2,
                ),
                Row(
                  children: [
                    Text(
                      movie.voteAverage.toString(),
                      style: theme.textTheme.bodyText2?.copyWith(
                        color: theme.textTheme.bodyText2?.color?.withOpacity(0.62),
                      ),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: Colors.amber,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
