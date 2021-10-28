import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_recommendation_app_course/theme/palette.dart';

class FrontBanner extends StatelessWidget {
  const FrontBanner({
    Key? key,
    required this.text,
    required this.platforms,
  }) : super(key: key);

  final String text;
  final List<String> platforms;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            height: 300,
            decoration: BoxDecoration(
               
                
                boxShadow: [
                  BoxShadow(
                    
                    color: Palette.red500.withAlpha(60),
                    blurRadius: 10,
                    spreadRadius: 0.0,
                    offset: const Offset(
                      0.0,
                      3.0,
                    ),
                  ),
                ]),
            
           padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold ,letterSpacing: 2),
                    
                    textAlign: TextAlign.center,
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
