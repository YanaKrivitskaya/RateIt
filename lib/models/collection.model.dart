import 'dart:convert';

import 'package:flutter/material.dart';

import 'attachment.model.dart';
import 'collection_item.model.dart';
import 'collection_property.model.dart';

@immutable
class Collection{
  final int? id;
  final String? name;
  final String? description;
  final Attachment? attachment;
  final List<CollectionProperty>? properties;
  final List<CollectionItem>? items;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const Collection({
    this.id,
    this.name,
    this.description,
    this.attachment,
    this.properties,
    this.items,
    this.createdDate,
    this.updatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      attachment: map['attachments'] != null ? Attachment.fromMap(map['attachments']) : null,
      properties: map['properties'] != null ? List<CollectionProperty>.from(map['properties']?.map((x) => CollectionProperty.fromMap(x))) : null,
      items: map['items'] != null ? List<CollectionItem>.from(map['items']?.map((x) => CollectionItem.fromMap(x))) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Collection.fromJson(String source) => Collection.fromMap(jsonDecode(source));
}