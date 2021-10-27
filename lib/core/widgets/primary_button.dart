import 'package:flutter/material.dart';

import 'package:movie_recommendation_app_course/core/constants.dart';
import 'package:movie_recommendation_app_course/theme/palette.dart';

import '../../responsive.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width,
    this.isLoading = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius / 2),
            ),
            fixedSize: Size(width ?? (Responsive.isTablet(context) || Responsive.isDesktop(context) ? 450 : double.infinity), 48)),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator(color: Palette.red300,)
            else
              Text(
                text,
                style: Theme.of(context).textTheme.button,
              ),
          ],
        ),
      ),
    );
  }
}
