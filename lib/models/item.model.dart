import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rateit/models/attachment.model.dart';
import 'package:rateit/models/property.model.dart';

@immutable
class Item{
  final int? id;
  final String? name;
  final String? description;
  final double? rating;
  final DateTime? date;
  final List<Attachment>? attachments;
  final List<Property>? properties;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const Item({
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

  factory Item.fromMap(Map<String, dynamic> map) {

    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      rating: map['rating'] != null ? (map['rating']).toDouble() : null,
      date: DateTime.parse(map['date']),
      attachments: map['attachments'] != null ? List<Attachment>.from(map['attachments']?.map((x) => Attachment.fromMap(x))) : null,
      properties: map['properties'] != null ? List<Property>.from(map['properties']?.map((x) => Property.fromMap(x))) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(jsonDecode(source));

  Item copyWith({
    int? id,
    String? name,
    String? description,
    double? rating,
    DateTime? date,
    List<Attachment>? attachments,
    List<Property>? properties,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Item(
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