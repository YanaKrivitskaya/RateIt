
import 'dart:convert';

class ApiPropertyValueModel{
  int itemId;
  List<ApiPropertyValue> data;

  ApiPropertyValueModel(this.itemId, this.data);

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'data': data.map((d) => d.toMap()).toList(),
    };
  }
  String toJson() => jsonEncode(toMap());
}

class ApiPropertyValue{
  int itemId;
  int propertyId;
  String value;

  ApiPropertyValue(this.itemId, this.propertyId, this.value);

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'propertyId': propertyId,
      'value': value,
    };
  }
}