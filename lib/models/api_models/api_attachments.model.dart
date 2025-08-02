
import 'dart:convert';
import 'dart:typed_data';

class ApiAttachmentModel{
  Uint8List source;
  String filename;

  ApiAttachmentModel(this.source, this.filename);

  Map<String, dynamic> toMap() {
    return {
      'source': source,
      'filename': filename
    };
  }
  String toJson() => jsonEncode(toMap());
}