import 'package:flutter/material.dart';

class User {
  final int? userId;
  final String username;
  final String password;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? account;
  User({
    Key? key,
    required this.username,
    required this.password,
    this.account,
    this.userId,
    this.name,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'password': password,
        'account': account,
        'name': name,
        'firstName': firstName,
        'lastName': lastName,
      };

  User.fromMap(Map<dynamic, dynamic> map)
      : userId = map['userId'] ?? 0,
        username = map['username'] ?? "",
        password = map['password'] ?? "",
        account = map['account'] ?? "",
        name = map['name'] ?? "",
        firstName = map['firstName'] ?? "",
        lastName = map['lastName'] ?? "";

  String toString() => toJson().toString();
}
