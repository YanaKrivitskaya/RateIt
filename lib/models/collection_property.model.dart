
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class CollectionProperty{
  final int? id;
  final String? name;
  final String? type;
  final String? comment;
  final String? value;
  final bool? isFilter;
  final bool? isDropdown;
  final List<String>? dropdownOptions;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const CollectionProperty({
    this.id,
    this.name,
    this.type,
    this.comment,
    this.value,
    this.isFilter,
    this.isDropdown,
    this.dropdownOptions,
    this.createdDate,
    this.updatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'comment': comment,
      //'value': value,
      'isFilter': isFilter,
      'isDropdown': isDropdown,
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
    };
  }

  factory CollectionProperty.fromMap(Map<String, dynamic> map) {
    return CollectionProperty(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      comment: map['comment'],
      value: map['collection_item_value'] != null ? map['collection_item_value']['value'].toString() : null,
      isFilter: map['isFilter'],
      isDropdown: map['isDropdown'],
      dropdownOptions: map['dropdown_values'] != null ? List<String>.from(map['dropdown_values']?.map((d) => d['value'].toString())) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CollectionProperty.fromJson(String source) => CollectionProperty.fromMap(jsonDecode(source));
}