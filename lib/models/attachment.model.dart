import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

@immutable
class Attachment{
  final int? id;
  final String? name;
  final Uint8List? source;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const Attachment({
    this.id,
    this.name,
    required this.source,
    this.createdDate,
    this.updatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
    };
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['id'] as int,
      name: map['name'] as String,
      source: map['source'] != null ? Uint8List.fromList(map['source']['data'].cast<int>()) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Attachment.fromJson(String source) => Attachment.fromMap(jsonDecode(source));
}