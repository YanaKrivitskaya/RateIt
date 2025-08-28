import 'dart:convert';

class ApiDropdownModel{
  List<ApiDropdownValue> data;

  ApiDropdownModel(this.data);

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((d) => d.toMap()).toList(),
    };
  }
  String toJson() => jsonEncode(toMap());
}

class ApiDropdownValue{
  int propertyId;
  String value;

  ApiDropdownValue(this.propertyId, this.value);

  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'value': value,
    };
  }
}