
import 'dart:convert';

class ApiCreatePropertyValueModel{
  int itemId;
  List<ApiPropertyValue> data;

  ApiCreatePropertyValueModel(this.itemId, this.data);

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'data': data.map((d) => d.toMap()).toList(),
    };
  }
  String toJson() => jsonEncode(toMap());
}

class ApiUpdatePropertyValueModel{
  List<ApiPropertyValue> data;

  ApiUpdatePropertyValueModel(this.data);

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((d) => d.toMap()).toList(),
    };
  }
  String toJson() => jsonEncode(toMap());
}

class ApiPropertyValue{
  int? id;
  int? itemId;
  int? propertyId;
  String value;

  ApiPropertyValue({
    this.id,
    this.itemId,
    this.propertyId,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'propertyId': propertyId,
      'value': value,
    };
  }

}