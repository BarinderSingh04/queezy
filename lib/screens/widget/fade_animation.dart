import 'package:flutter/material.dart';

class FadingImage extends StatefulWidget {
  final String imageUrl;
  final Duration duration;

  const FadingImage({
    super.key,
    required this.imageUrl,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<FadingImage> createState() => _FadingImageState();
}

class _FadingImageState extends State<FadingImage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start fade after a small delay
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: Image.asset(widget.imageUrl), // or use Image.network()
    );
  }
}
