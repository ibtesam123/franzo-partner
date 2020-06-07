import 'package:flutter/material.dart';


class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Completed Leads',
        style: TextStyle(color: Colors.white),
      ),
      elevation: 4,
      backgroundColor: Colors.black,
      
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: _buildAppBar(),
      
    );
  }
}