
import 'package:flutter/material.dart';
import 'package:rateit/models/property.model.dart';

class FilterModel{
  final RangeValues? rating;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<Property>? properties;

  const FilterModel({
    this.rating,
    this.dateFrom,
    this.dateTo,
    this.properties,
  });

  FilterModel copyWith({
    RangeValues? rating,
    DateTime? dateFrom,
    DateTime? dateTo,
    List<Property>? properties,
  }) {
    return FilterModel(
      rating: rating ?? this.rating,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      properties: properties ?? this.properties,
    );
  }
}
