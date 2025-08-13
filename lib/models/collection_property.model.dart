
import 'dart:convert';
import 'dart:math';

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
  final int? minValue;
  final int? maxValue;
  final int? order;
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
    this.minValue,
    this.maxValue,
    this.order,
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
      'minValue': minValue,
      'maxValue': maxValue,
      'order': order,
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
      minValue: map['minValue'],
      maxValue: map['maxValue'],
      order: map['order'],
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
    int? minValue,
    int? maxValue,
    int? order,
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
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      order: order ?? this.order,
      dropdownOptions: dropdownOptions ?? this.dropdownOptions,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}