import 'package:flutter/material.dart';

import '../OrdersPageView/BiddingOrderPage.dart';
import '../OrdersPageView/NormalOrderPage.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  TabBar _buildTabBarItems() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.white,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      indicator:
          UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white)),
      tabs: <Widget>[
        Tab(
          text: 'BIDDING',
        ),
        Tab(
          text: 'NORMAL',
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'My Leads',
        style: TextStyle(color: Colors.white),
      ),
      elevation: 4,
      backgroundColor: Colors.black,
      bottom: _buildTabBarItems(),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        BiddingOrderPage(),
        NormalOrderPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
