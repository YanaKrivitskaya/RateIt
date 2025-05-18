import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class Account{
  final int? id;
  final String? name;
  final String? email;
  final bool? emailVerified;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final bool? disabled;
  final DateTime? disabledDate;

  Account({
    this.id,
    this.name,
    this.email,
    this.emailVerified,
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
      'emailVerified': emailVerified,
      'createdDate': createdDate?.microsecondsSinceEpoch,
      'updatedDate': updatedDate?.microsecondsSinceEpoch,
      'disabled': disabled,
      'disabledDate': disabledDate?.microsecondsSinceEpoch,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      emailVerified: map['emailVerified'] as bool,
      createdDate: map['createdDate'] as DateTime,
      updatedDate: map['updatedDate'] as DateTime,
      disabled: map['disabled'] as bool,
      disabledDate: map['disabledDate']!= null ? map['disabledDate'] as DateTime : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Account.fromJson(String source) => Account.fromMap(jsonDecode(source));
}

