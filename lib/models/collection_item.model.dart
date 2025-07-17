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
  final DateTime? date;
  final List<Attachment>? attachments;
  final List<CollectionProperty>? properties;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const CollectionItem({
    this.id,
    this.name,
    this.description,
    this.rating,
    this.date,
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
      'date': date?.toIso8601String(),
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
    };
  }

  factory CollectionItem.fromMap(Map<String, dynamic> map) {

    return CollectionItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      rating: map['rating'] != null ? (map['rating']).toDouble() : null,
      date: DateTime.parse(map['date']),
      attachments: map['attachments'] != null ? List<Attachment>.from(map['attachments']?.map((x) => Attachment.fromMap(x))) : null,
      properties: map['properties'] != null ? List<CollectionProperty>.from(map['properties']?.map((x) => CollectionProperty.fromMap(x))) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CollectionItem.fromJson(String source) => CollectionItem.fromMap(jsonDecode(source));

  CollectionItem copyWith({
    int? id,
    String? name,
    String? description,
    double? rating,
    DateTime? date,
    List<Attachment>? attachments,
    List<CollectionProperty>? properties,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return CollectionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      attachments: attachments ?? this.attachments,
      properties: properties ?? this.properties,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}