

import 'package:flutter/material.dart';

class AnimatedPoints extends StatelessWidget {
  final int score;
  final Duration duration;
  final TextStyle? style;

  const AnimatedPoints({
    super.key,
    required this.score,
    this.duration = const Duration(seconds: 2),
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: score),
      duration: duration,
      builder: (context, value, _) {
        return Text(
          'You get +$value points',
          style: style ?? Theme.of(context).textTheme.headlineSmall,
        );
      },
    );
  }
}




class AnimatedScore extends StatelessWidget {
  final int score;
  final Duration duration;
  final TextStyle? style;

  const AnimatedScore({
    super.key,
    required this.score,
    this.duration = const Duration(seconds: 2),
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: score),
      duration: duration,
      builder: (context, value, _) {
        return Text(
          ' $value',
          style: style ?? Theme.of(context).textTheme.headlineSmall,
        );
      },
    );
  }
}

