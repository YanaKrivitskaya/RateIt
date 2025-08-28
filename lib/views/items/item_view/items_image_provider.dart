
import 'dart:typed_data';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:rateit/models/attachment.model.dart';

class ItemsImageProvider extends EasyImageProvider {

  final List<Attachment> attachments;
  final int initialIndex;

  ItemsImageProvider({ required this.attachments, this.initialIndex = 0 });

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    Uint8List? source = attachments[index].source;

    ImageProvider imageProvider = source != null
        ? MemoryImage(source)
        : AssetImage("assets/placeholder_image.jpg") as ImageProvider;

    return imageProvider;
  }

  @override
  int get imageCount => attachments.length;
}