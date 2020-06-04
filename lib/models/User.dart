import 'package:flutter/material.dart';

class User {
  String uid, name, email;
  int serviceID;
  List<String> orders;

  User({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.serviceID,
    @required this.orders,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    List<String> _orders = List<String>();
    for (String m in map['orders']) _orders.add(m);
    return User(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      serviceID: map['serviceID'],
      orders: _orders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'orders': orders,
      'serviceID': serviceID,
    };
  }
}
