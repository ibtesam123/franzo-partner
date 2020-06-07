import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './scoped_model/MainModel.dart';
import './pages/SplashPage.dart';
import './pages/auth/LoginPage.dart';
import './pages/auth/SignupPage.dart';
import './pages/HomePage.dart';
import './pages/BiddingPage.dart';
import './utils/ArgumentClasses.dart';

void main() {
  MainModel _model = MainModel();
  runApp(MyMaterial(model: _model));
}

class MyMaterial extends StatelessWidget {
  final MainModel model;
  MyMaterial({@required this.model});

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      
      child: MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.grey
      ),
        routes: {
          '/': (context) => SplashPage(),
          '/LoginPage': (context) => LoginPage(),
          '/SignupPage': (context) => SignupPage(),
          '/HomePage': (context) => HomePage(),
        },
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/BiddingPage':
              BiddingPageClass _argument = settings.arguments;
              return MaterialPageRoute(
                builder: (_) => BiddingPage(order: _argument.order),
              );
              default:
              return null;
          }
        },
      ),
    );
  }
}
