import 'package:flutter/cupertino.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork({Key? key, required this.src}) : super(key: key);
  final String src;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/image_placeholder.png'),
    );
  }
}
