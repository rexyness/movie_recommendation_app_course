import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app_course/features/movie_flow/movie_flow.dart';
import 'package:movie_recommendation_app_course/theme/custom_theme.dart';

import 'config/config_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
});



class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      title: 'Movie Recommendation',
      darkTheme: ref.watch(themeProvider)
          ? CustomTheme.darkTheme(context)
          : CustomTheme.lightTheme(context),
      themeMode: ThemeMode.dark,
      home: const MovieFlow(),
    );
  }
}
