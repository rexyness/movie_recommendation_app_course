import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app_course/core/constants.dart';
import 'package:movie_recommendation_app_course/core/failure.dart';
import 'package:movie_recommendation_app_course/core/widgets/failure_screen.dart';
import 'package:movie_recommendation_app_course/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_flow_controller.dart';

import 'list_card.dart';

class GenreScreen extends ConsumerWidget {
  const GenreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: ref.read(movieFlowControllerProvider.notifier).previousPage,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Let\'s start with a genre',
              style: theme.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: ref.watch(movieFlowControllerProvider).genres.when(data: (genres) {
              return Scrollbar(
                isAlwaysShown: true,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: kListItemSpacing),
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    return ListCard(
                      genre: genre,
                      onTap: () => ref.read(movieFlowControllerProvider.notifier).toggleSelected(genre),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: kListItemSpacing);
                  },
                ),
              );
            }, error: (e, s, data) {
              if (e is Failure) return FailureBody(message: e.message);
              return const FailureBody(message: 'Something went wrong');
            }, loading: (_) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            })),
            PrimaryButton(
              onPressed: ref.read(movieFlowControllerProvider.notifier).nextPage,
              text: 'Continue',
            ),
            const SizedBox(height: kMediumSpacing),
          ],
        ),
      ),
    );
  }
}
