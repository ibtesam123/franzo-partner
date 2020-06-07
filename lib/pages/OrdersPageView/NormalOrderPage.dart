import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../scoped_model/MainModel.dart';
import '../../models/Order.dart';

class NormalOrderPage extends StatefulWidget {
  @override
  _NormalOrderPageState createState() => _NormalOrderPageState();
}

class _NormalOrderPageState extends State<NormalOrderPage> {
  MainModel _staticModel;

  @override
  void initState() {
    super.initState();
    _staticModel = ScopedModel.of<MainModel>(context, rebuildOnChange: false);
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

  Widget _buildOngoingText() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Text(
        'ONGOING',
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLocation() {
    return Row(
      children: <Widget>[
        Icon(Icons.location_on),
        Text(
          'Location of the customer',
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget _buildOrderName() {
    return Text(
      'Customer Name',
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOrderSubService(String service, String subService) {
    return Text(
      service + " ( " + subService + " )",
      style: TextStyle(color: Colors.black87),
    );
  }

  Widget _buildOrderStatus(String status) {
    return Text(
      status,
      style: TextStyle(fontSize: 12.0, color: Colors.black45),
    );
  }

  Widget _buildSingleOrder(Order order) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed('/OrderDetailsPage',
        //     arguments: OrderDetailsClass(order.orderID));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.black54, width: 1.0),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildOrderName(),
                _buildOngoingText(),
              ],
            ),
            _buildOrderSubService(order.serviceName, order.subService),
            SizedBox(height: 10.0),
            _buildOrderDetail(order.desc),
            SizedBox(height: 10.0),
            _buildLocation(),
            SizedBox(
              height: 10,
            ),
            _buildOrderStatus('Order placed on ...'),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[200],
      child: StreamBuilder<QuerySnapshot>(
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
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Color(0XFF000000),
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ));
          }
        },
        stream: _staticModel.getNormalOrderStream(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
