
import 'package:flutter/material.dart';
import 'package:rateit/models/collection_property.model.dart';

class FilterModel{
  final RangeValues? rating;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<CollectionProperty>? properties;

  FilterModel(this.rating, this.dateFrom, this.dateTo, this.properties);
}
