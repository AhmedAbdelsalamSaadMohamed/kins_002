import 'package:flutter/material.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork({Key? key, required this.src}) : super(key: key);
  final String src;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(
        src,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/image_placeholder.png'),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}
