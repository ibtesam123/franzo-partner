import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_model/MainModel.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          labelText: 'E-MAIL',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          labelText: 'PASSWORD',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Required';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildEmail(),
          SizedBox(
            height: 15,
          ),
          _buildPassword(),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: MaterialButton(
          height: 40,
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.black,
          onPressed: () async {
            if (model.isLoading == -1) {
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();

              var _res =
                  await model.loginUser(email: _email, password: _password);
              if (_res)
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/HomePage',
                  (route) => false,
                );
            }
          },
          child: model.isLoading == 1
              ? CircularProgressIndicator()
              : Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      );
    });
  }

  Widget _buildSignUpButton() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            
          ),
          child: MaterialButton(
            height: 40,
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () async {
              Navigator.of(context).pushNamed('/SignupPage');
            },
            child: Text(
              'Sign-up',
              style: TextStyle(),
            ),
          ),
        ));
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'F R A N Z O',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        Text(
          'M E R C H A N T',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 15,
        ),
        _buildLoginForm(),
        SizedBox(
          height: 20,
        ),
        _buildLoginButton(),
        SizedBox(
          height: 15,
        ),
        _buildSignUpButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
