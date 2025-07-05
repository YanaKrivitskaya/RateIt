
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum AttState {keep, create, delete}

@immutable
class AttachmentViewModel{
  final int? id;
  final Uint8List? source;
  final XFile? file;
  AttState state;

  AttachmentViewModel({
    this.id,
    this.source,
    this.file,
    required this.state,
  });

}