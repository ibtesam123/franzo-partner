import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/User.dart';
import '../models/Order.dart';
import '../models/BidPrice.dart';

mixin ConnectedModel on Model {
  int _isLoading;
  FirebaseAuth _fAuth;
  FirebaseUser _fUser;
  Firestore _remoteDB;
  User _currentUser;
  List<Map<String, dynamic>> _services = [
    {
      'serviceName': 'Cleaning Service',
      'id': 0,
      'subService': [
        {
          'id': 0,
          'name': 'BathRoom',
          'image': 'assets/images/listing/room.jpg',
          'price': 200,
        },
        {
          'id': 1,
          'name': 'Sofa',
          'image': 'assets/images/listing/room.jpg',
          'price': 150,
        },
        {
          'id': 2,
          'name': 'Kitchen',
          'image': 'assets/images/listing/room.jpg',
          'price': 600,
        },
      ],
      'image': 'assets/images/listing/room.jpg',
    },
    {
      'serviceName': 'Home Repair',
      'id': 1,
      'subService': [
        {
          'id': 3,
          'name': 'Plumber',
          'image': 'assets/images/listing/electric.jpg',
          'price': 150,
        },
        {
          'id': 4,
          'name': 'Electrician',
          'image': 'assets/images/listing/electric.jpg',
          'price': 180,
        },
        {
          'id': 5,
          'name': 'Carpenter',
          'image': 'assets/images/listing/electric.jpg',
          'price': 280,
        },
      ],
      'image': 'assets/images/listing/electric.jpg',
    },
    {
      'serviceName': 'Saloon Service',
      'id': 2,
      'subService': [
        {
          'id': 6,
          'name': 'Grooming',
          'image': 'assets/images/listing/grooming.jpg',
          'price': 750,
        },
        {
          'id': 7,
          'name': 'Hair Cut',
          'image': 'assets/images/listing/grooming.jpg',
          'price': 150,
        },
        {
          'id': 8,
          'name': 'Massage',
          'image': 'assets/images/listing/grooming.jpg',
          'price': 800,
        },
      ],
      'image': 'assets/images/listing/grooming.jpg',
    },
    {
      'serviceName': 'Electronic Repair',
      'id': 3,
      'subService': [
        {
          'id': 9,
          'name': 'Laptops',
          'image': 'assets/images/listing/electronic.jpg',
          'price': 450,
        },
        {
          'id': 10,
          'name': 'Mobiles',
          'image': 'assets/images/listing/electronic.jpg',
          'price': 200,
        },
      ],
      'image': 'assets/images/listing/electronic.jpg',
    }
  ];
}

/* isLoading
 * 1: login
 * 2: signup
*/

mixin UserModel on ConnectedModel {
  Future<bool> loginUser({
    @required String email,
    @required String password,
  }) async {
    try {
      _isLoading = 1;
      notifyListeners();

      AuthResult _res = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _fUser = _res.user;

      if (_fUser == null) {
        _isLoading = -1;
        notifyListeners();
        return false;
      }

      print(_fUser.uid);

      _isLoading = -1;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = -1;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signupUser({
    @required String name,
    @required String email,
    @required String password,
    @required int serviceID,
  }) async {
    try {
      _isLoading = 2;
      notifyListeners();

      var _res = await _fAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _fUser = _res.user;

      if (_fUser == null) {
        _isLoading = -1;
        notifyListeners();
        return false;
      }

      _currentUser = User(
        uid: _fUser.uid,
        name: name,
        email: email,
        serviceID: serviceID,
        orders: List<String>(),
      );

      _remoteDB
          .collection('PARTNERS')
          .document(_currentUser.uid)
          .setData(_currentUser.toMap());

      _isLoading = -1;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = -1;
      notifyListeners();
      return false;
    }
  }
}

mixin OrderModel on ConnectedModel {
  Stream<QuerySnapshot> getBiddingOrderStream() {
    return _remoteDB
        .collection('ORDERS')
        .where('serviceID', isEqualTo: _currentUser.serviceID)
        .where('bidEnabled', isEqualTo: true)
        .where('isComplete', isEqualTo: false)
        .getDocuments()
        .asStream();
  }

  Stream<QuerySnapshot> getNormalOrderStream() {
    return _remoteDB
        .collection('ORDERS')
        .where('companyID', isEqualTo: _currentUser.uid)
        .where('isComplete', isEqualTo: false)
        .getDocuments()
        .asStream();
  }

  Stream<DocumentSnapshot> getBiddingStream(String orderID) {
    return _remoteDB.collection('ORDERS').document(orderID).get().asStream();
  }

  void addBid(Order order, double price) {
    int index = order.price
        .indexWhere((element) => element.companyID == _currentUser.uid);
    if (index == -1) {
      order.price.add(BidPrice(
          companyID: _currentUser.uid,
          companyName: _currentUser.name,
          price: price));
    } else {
      order.price[index].setPrice(price);
    }

    _remoteDB
        .collection('ORDERS')
        .document(order.orderID)
        .setData(order.getMap(), merge: true);
  }
}

mixin UtilityModel on ConnectedModel {
  Future<bool> init() async {
    _isLoading = -1;
    _fAuth = FirebaseAuth.instance;
    _remoteDB = Firestore.instance;

    _fUser = await _fAuth.currentUser();
    if (_fUser == null)
      return false;
    else {
      var snap1 =
          await _remoteDB.collection('PARTNERS').document(_fUser.uid).get();
      _currentUser = User.fromMap(snap1.data);
      return true;
    }
  }

  int get isLoading => _isLoading;
  User get currentUser => _currentUser;
  List<Map<String, dynamic>> get services => _services;
}
