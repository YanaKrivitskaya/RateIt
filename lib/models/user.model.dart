import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class User{
  final int? id;
  final String? name;
  final String? email;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final bool? disabled;
  final DateTime? disabledDate;

  const User({
    this.id,
    this.name,
    this.email,
    this.createdDate,
    this.updatedDate,
    this.disabled,
    this.disabledDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
      'disabled': disabled,
      'disabledDate': disabledDate?.microsecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['username'],
      email: map['email'],
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
      disabled: map['disabled'],
      disabledDate: map['disabledDate']!= null ? DateTime.parse(map['disabledDate']) : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) => User.fromMap(jsonDecode(source));
}

