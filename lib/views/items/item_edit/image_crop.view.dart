import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rateit/helpers/colors.dart';

class ImageCropArguments {
  final File file;
  final int compress;
  ImageCropArguments({
    required this.file,
    required this.compress,
  });
}

class ImageCropView extends StatefulWidget {
  final File image;
  final int compress;

  const
  ImageCropView(this.image, this.compress, {super.key});

  @override
  _ImageCropViewState createState() => _ImageCropViewState();
}

class _ImageCropViewState extends State<ImageCropView> {
  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.image;
    if (imageFile != null) _cropImage(widget.compress);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height:0);
  }

  Future<Null> _cropImage(int compress) async {

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        compressQuality: compress < 100 ? compress : 100,
        aspectRatio: CropAspectRatio(ratioX: 10, ratioY: 10),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: ColorsPalette.algalFuel,
              hideBottomControls: false,
              toolbarWidgetColor: ColorsPalette.white,
              backgroundColor: ColorsPalette.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          )]);

    if (croppedFile != null) {
      Navigator.pop(context, croppedFile);
    }else{
      Navigator.pop(context, null);
    }

  }
}