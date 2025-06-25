import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'attachment.model.dart';
import 'collection_item.model.dart';
import 'collection_property.model.dart';

@immutable
class Collection{
  final int? id;
  final String? name;
  final String? description;
  final IconData? icon;
  final Color? colorPrimary;
  final Color? colorAccent;
  final Uint8List? imageSrc;
  final List<CollectionProperty>? properties;
  final List<CollectionItem>? items;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const Collection({
    this.id,
    this.name,
    this.description,
    this.icon,
    this.colorPrimary,
    this.colorAccent,
    this.imageSrc,
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
      'icon': icon?.codePoint,
      'colorPrimary': colorPrimary?.toARGB32(),
      'colorAccent': colorAccent?.toARGB32(),
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'] != null ? IconData(map['icon'], fontFamily: 'MaterialIcons') : null,
      colorPrimary: map['colorPrimary'] != null ? Color(map['colorPrimary']) : null,
      colorAccent: map['colorAccent'] != null ? Color(map['colorAccent']) : null,
      imageSrc: map['imageSrc'] != null ? Uint8List.fromList(map['imageSrc']['data'].cast<int>()) : null,
      properties: map['properties'] != null ? List<CollectionProperty>.from(map['properties']?.map((x) => CollectionProperty.fromMap(x))) : null,
      items: map['items'] != null ? List<CollectionItem>.from(map['items']?.map((x) => CollectionItem.fromMap(x))) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Collection.fromJson(String source) => Collection.fromMap(jsonDecode(source));

  Collection copyWith({
    int? id,
    String? name,
    String? description,
    IconData? icon,
    Color? colorPrimary,
    Color? colorAccent,
    Uint8List? imageSrc,
    List<CollectionProperty>? properties,
    List<CollectionItem>? items,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorAccent: colorAccent ?? this.colorAccent,
      imageSrc: imageSrc ?? this.imageSrc,
      properties: properties ?? this.properties,

      items: items ?? this.items,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  @override
  String toString() {
    return 'Collection{id: $id, name: $name, description: $description, icon: $icon, colorPrimary: $colorPrimary, colorAccent: $colorAccent, imageSrc: $imageSrc, properties: $properties, items: $items, createdDate: $createdDate, updatedDate: $updatedDate}';
  }
}