import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

@immutable
class Attachment{
  final int? id;
  final String? originalName;
  final String? path;
  Uint8List? source;
  bool toDelete;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  Attachment({
    this.id,
    this.originalName,
    this.path,
    this.source,
    this.toDelete = false,
    this.createdDate,
    this.updatedDate,
  });

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['id'],
      originalName: map['originalName'],
      path: map['path'],
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  factory Attachment.fromJson(String source) => Attachment.fromMap(jsonDecode(source));

  Attachment copyWith({
    int? id,
    String? originalName,
    String? path,
    Uint8List? source,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Attachment(
      id: id ?? this.id,
      originalName: originalName ?? this.originalName,
      path: path ?? this.path,
      source: source ?? this.source,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}