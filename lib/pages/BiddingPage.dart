import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_model/MainModel.dart';
import '../models/Order.dart';

class BiddingPage extends StatefulWidget {
  final Order order;
  BiddingPage({@required this.order});

  @override
  _BiddingPageState createState() => _BiddingPageState();
}

class _BiddingPageState extends State<BiddingPage> {
  MainModel _staticModel;
  double _height, _width;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _staticModel = ScopedModel.of(context, rebuildOnChange: false);
  }

  Widget _buildBidList() {
    return StreamBuilder<DocumentSnapshot>(
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          Order _order = Order.fromMap(map: snapshot.data.data);
          return Container(
            height: _height * 0.5,
            width: _width,
            child: ListView.builder(
              itemBuilder: (_, index) {
                return Text(
                  _order.price[index].companyName == null
                      ? 'Bid Starting at ${_order.price[index].price.toString()}'
                      : _order.price[index].companyName +
                          ' : ' +
                          _order.price[index].price.toString(),
                  textAlign: TextAlign.center,
                );
              },
              itemCount: _order.price.length,
            ),
          );
        } else
          return Container();
      },
      stream: _staticModel.getBiddingStream(widget.order.orderID),
    );
  }

  Widget _buildBidInput() {
    return Container(
      width: _width * 0.7,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter your bid'),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildBidButton() {
    return MaterialButton(
      onPressed: () {
        if (_controller.text.isEmpty) return;

        _staticModel.addBid(widget.order, double.parse(_controller.text));
        _controller.text = '';

        this.setState(() {});
      },
      child: Text('BID'),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: _height * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildBidList(),
          _buildBidInput(),
          _buildBidButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _buildBody(),
    );
  }
}
