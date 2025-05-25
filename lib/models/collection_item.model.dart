import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rateit/models/attachment.model.dart';
import 'package:rateit/models/collection_property.model.dart';

@immutable
class CollectionItem{
  final int? id;
  final String? name;
  final String? description;
  final double? rating;
  final List<Attachment>? attachments;
  final List<CollectionProperty>? properties;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const CollectionItem({
    this.id,
    this.name,
    this.description,
    this.rating,
    this.attachments,
    this.properties,
    this.createdDate,
    this.updatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rating': rating,
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
    };
  }

  factory CollectionItem.fromMap(Map<String, dynamic> map) {
    return CollectionItem(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      rating: map['rating'] as double,
      attachments: map['attachments'] != null ? List<Attachment>.from(map['attachments']?.map((x) => Attachment.fromMap(x))) : null,
      properties: map['properties'] != null ? List<CollectionProperty>.from(map['properties']?.map((x) => CollectionProperty.fromMap(x))) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CollectionItem.fromJson(String source) => CollectionItem.fromMap(jsonDecode(source));
}