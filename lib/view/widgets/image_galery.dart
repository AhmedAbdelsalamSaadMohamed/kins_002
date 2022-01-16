import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/view/widgets/custom_image_network.dart';

class _ImageGalleryWidget extends StatelessWidget {
  _ImageGalleryWidget(
      {Key? key,
      required this.images,
      required this.initial,
      this.fromFile = false})
      : super(key: key);
  final List<String> images;
  final int initial;
  bool fromFile;

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
                return InteractiveViewer(
                    child: fromFile
                        ? Image.file(File(e))
                        : CustomImageNetwork(src: e));
              })
            ],
          ),
        ),
      ),
    );
  }
}

void showImagesGallery(
    {required List<String> images,
    required int initial,
    bool fromFile = false}) {
  Get.dialog(
    Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _ImageGalleryWidget(
            images: [...images],
            initial: initial,
            fromFile: fromFile,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                )),
          )
        ],
      ),
    ),
    barrierColor: Colors.black,
  );
}
