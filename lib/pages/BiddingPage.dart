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

  Widget _buildStartingBid(Order _order, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.black54, width: 1.0),
          color: Colors.white),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Starting at'),
          Text(
            'Rs. ${_order.price[index].price.toString()}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          )
        ],
      )),
    );
  }

  Widget _buildOthersBid(Order _order, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 5),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.black54, width: 1.0),
          color: Colors.white),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_order.price[index].companyName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          Text(
            "Rs. " + _order.price[index].price.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          )
        ],
      )),
    );
  }

  Widget _buildBidList() {
    return Expanded(
      child: StreamBuilder<DocumentSnapshot>(
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            Order _order = Order.fromMap(map: snapshot.data.data);
            return Container(
              height: _height * 0.5,
              width: _width,
              child: ListView.builder(
                itemBuilder: (_, index) {
                  return _order.price[index].companyName == null
                      ? _buildStartingBid(_order, index)
                      : _buildOthersBid(_order, index);
                },
                itemCount: _order.price.length,
              ),
            );
          } else
            return Padding(
              padding: EdgeInsets.only(top: _height * 0.4),
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Color(0XFF000000),
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              )),
            );
        },
        stream: _staticModel.getBiddingStream(widget.order.orderID),
      ),
    );
  }

  Widget _buildBidInput() {
    return Container(
      width: _width * 0.8,
      height: _height * 0.05,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter your bid',
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildBidButton() {
    return Container(
      width: _width * 0.17,
      color: Colors.black,
      child: MaterialButton(
        onPressed: () {
          if (_controller.text.isEmpty) return;

          _staticModel.addBid(widget.order, double.parse(_controller.text));
          _controller.text = '';

          this.setState(() {});
        },
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.only(top: _height * 0.02),
      child: Column(
        children: <Widget>[_buildBidList(), _buildBiddingInput()],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Bidding Page',
        style: TextStyle(color: Colors.white),
      ),
      elevation: 4,
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBiddingInput() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.only(bottom: 10),
      width: _width,
      child: Row(
        children: <Widget>[_buildBidInput(), _buildBidButton()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
