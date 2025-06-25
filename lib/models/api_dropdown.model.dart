import 'dart:convert';

class ApiDropdownModel{
  int propertyId;
  List<ApiDropdownValue> data;

  ApiDropdownModel(this.propertyId, this.data);

  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
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
      'propertyId': this.propertyId,
      'value': this.value,
    };
  }
  //String toJson() => jsonEncode(toMap());
}