import 'package:flutter/foundation.dart';

import './BidPrice.dart';

class Order {
  final String serviceName, desc, orderID, subService;
  String imageURL;
  final int count, serviceID, subServiceID;
  double lat, long;
  final bool isComplete, bidEnabled;
  final List<BidPrice> price;

  Order({
    
    @required this.serviceName,
    @required this.desc,
    @required this.serviceID,
    @required this.subServiceID,
    @required this.count,
    @required this.subService,
    @required this.isComplete,
    @required this.orderID,
    @required this.price,
    @required this.bidEnabled,
    this.lat,
    this.long,
    this.imageURL = "null",
  });

  void setLocation(double long, double lat) {
    this.lat = lat;
    this.long = long;
  }


  void setImageURL(String imageURL) {
    this.imageURL = imageURL;
  }

  factory Order.fromMap({@required Map<String, dynamic> map}) {
    List<BidPrice> _price = List<BidPrice>();
    for (Map<String, dynamic> bid in map['price'])
      _price.add(BidPrice.fromMap(bid));

    return Order(
      count: map['count'],
      desc: map['desc'],
      orderID: map['orderID'],
      serviceID: map['serviceID'],
      subServiceID: map['subServiceID'],
      price: _price,
      lat: map['lat'],
      bidEnabled: map['bidEnabled'],
      subService: map['subService'],
      long: map['long'],
      imageURL: map['imageURL'],
      isComplete: map['isComplete'],
      serviceName: map['serviceName'],
      
    );
  }

  Map<String, dynamic> getMap() {
    List<Map<String, dynamic>> _price = List<Map<String, dynamic>>();
    for (BidPrice bid in price) _price.add(bid.toMap());
    return {
      'count': count,
      'serviceName': serviceName,
      'desc': desc,
      'orderID': orderID,
      'imageURL': imageURL,
      'price': _price,
      'serviceID': serviceID,
      'subServiceID': subServiceID,
      'bidEnabled': bidEnabled,
      'subService': subService,
      'lat': lat,
      'long': long,
      'isComplete': isComplete,
    };
  }
}
