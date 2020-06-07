import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_model/MainModel.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    ScopedModel.of<MainModel>(context, rebuildOnChange: false)
        .init()
        .then((isSignedIn) {
      if (isSignedIn)
        Navigator.of(context).pushReplacementNamed('/HomePage');
      else
        Navigator.of(context).pushReplacementNamed('/LoginPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/FRANZO.png'),
            CircularProgressIndicator(backgroundColor: Color(0XFF000000),valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
          ],
        )
      ),
    );
  }
}
