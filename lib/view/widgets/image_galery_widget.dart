import 'package:flutter/material.dart';
import 'package:kins_v002/view/widgets/custom_image_network.dart';

class ImageGalleryWidget extends StatelessWidget {
  const ImageGalleryWidget({Key? key, required this.images}) : super(key: key);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black54,
      insetPadding: EdgeInsets.all(2),
      child: Container(
        child: DefaultTabController(
          length: images.length,
          child: TabBarView(
            children: [
              ...images.map((e) {
                return InteractiveViewer(child: CustomImageNetwork(src: e));
              })
            ],
          ),
        ),
      ),
    );
  }
}
