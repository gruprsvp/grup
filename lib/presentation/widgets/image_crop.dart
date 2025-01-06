import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class ImageCrop extends StatefulWidget {
  final Uint8List imageData;
  final ValueSetter<Uint8List>? onCrop;

  const ImageCrop({super.key, required this.imageData, this.onCrop});

  @override
  ImageCropState createState() => ImageCropState();
}

class ImageCropState extends State<ImageCrop> {
  final _controller = CropController();

  @override
  Widget build(BuildContext context) {
    final imageData = widget.imageData;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.cut),
            onPressed: () {
              _controller.crop();
            },
          ),
        ],
      ),
      body: Crop(
        controller: _controller,
        image: imageData,
        aspectRatio: 1,
        initialSize: 0.7,
        interactive: true,
        withCircleUi: true,
        progressIndicator: const Center(child: CircularProgressIndicator()),
        onCropped: (result) {
          if (widget.onCrop != null) {
            widget.onCrop!(result);
          }
        },
      ),
    );
  }
}
