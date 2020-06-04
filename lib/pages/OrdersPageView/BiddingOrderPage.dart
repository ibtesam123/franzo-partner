import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_model/MainModel.dart';
import '../../models/Order.dart';
import '../../utils/ArgumentClasses.dart';

class BiddingOrderPage extends StatefulWidget {
  @override
  _BiddingOrderPageState createState() => _BiddingOrderPageState();
}

class _BiddingOrderPageState extends State<BiddingOrderPage> {
  MainModel _staticModel;

  @override
  void initState() {
    super.initState();
    _staticModel = ScopedModel.of<MainModel>(context, rebuildOnChange: false);
  }

  Widget _buildOrderTitle(String serviceName) {
    return Text(
      serviceName,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOrderSubService(String subService) {
    return Text(
      subService,
      style: TextStyle(color: Colors.black87),
    );
  }

  Widget _buildOrderDetail(String desc) {
    return desc.trim().length == 0
        ? Text(
            'No description provided.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15.0,
            ),
          )
        : Text(
            desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15.0),
          );
  }

  Widget _buildSingleOrder(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/BiddingPage',
          arguments: BiddingPageClass(order),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.black54, width: 1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildOrderTitle(order.serviceName),
            _buildOrderSubService(order.subService),
            SizedBox(height: 10.0),
            _buildOrderDetail(order.desc)
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Order> _orders = List<Order>();
          for (DocumentSnapshot doc in snapshot.data.documents) {
            _orders.add(Order.fromMap(map: doc.data));
          }
          return ListView.builder(
            itemBuilder: (_, index) => _buildSingleOrder(_orders[index]),
            itemCount: _orders.length,
          );
        } else {
          return Container();
        }
      },
      stream: _staticModel.getBiddingOrderStream(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
