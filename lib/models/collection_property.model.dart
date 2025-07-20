
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class CollectionProperty{
  final int? id;
  final String? name;
  final String? type;
  final String? comment;
  final int? valueId;
  final String? value;
  final bool? isFilter;
  final bool? isDropdown;
  final bool? isRequired;
  final List<String>? dropdownOptions;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  const CollectionProperty({
    this.id,
    this.name,
    this.type,
    this.comment,
    this.valueId,
    this.value,
    this.isFilter,
    this.isDropdown,
    this.isRequired,
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
      'isFilter': isFilter,
      'isDropdown': isDropdown,
      'isRequired': isRequired,
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
      valueId: map['collection_item_value'] != null ? map['collection_item_value']['id'] : null,
      value: map['collection_item_value'] != null ? map['collection_item_value']['value'].toString() : null,
      isFilter: map['isFilter'],
      isDropdown: map['isDropdown'],
      isRequired: map['isRequired'],
      dropdownOptions: map['dropdown_values'] != null ? List<String>.from(map['dropdown_values']?.map((d) => d['value'].toString())) : null,
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CollectionProperty.fromJson(String source) => CollectionProperty.fromMap(jsonDecode(source));

  CollectionProperty copyWith({
    int? id,
    String? name,
    String? type,
    String? comment,
    int? valueId,
    String? value,
    bool? isFilter,
    bool? isDropdown,
    bool? isRequired,
    List<String>? dropdownOptions,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return CollectionProperty(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      comment: comment ?? this.comment,
      valueId: valueId ?? this.valueId,
      value: value ?? this.value,
      isFilter: isFilter ?? this.isFilter,
      isDropdown: isDropdown ?? this.isDropdown,
      isRequired: isRequired ?? this.isRequired,
      dropdownOptions: dropdownOptions ?? this.dropdownOptions,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}