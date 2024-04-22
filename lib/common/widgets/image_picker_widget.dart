import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';

class ImagePickerWidget extends StatelessWidget {
  final Uint8List? rawFile;
  final String image;
  final Function onTap;
  const ImagePickerWidget({super.key, required this.rawFile, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(child: Stack(children: [

      ClipOval(child: rawFile != null ? Image.memory(
        rawFile!, width: 100, height: 100, fit: BoxFit.cover,
      ) : CustomImage(image: image, height: 100, width: 100, fit: BoxFit.cover)),

      Positioned(
        bottom: 0, right: 0, top: 0, left: 0,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
            ),
            child: Container(
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    ]));
  }
}
