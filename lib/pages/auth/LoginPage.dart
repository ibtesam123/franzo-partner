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
    return TextFormField(
      decoration: InputDecoration(hintText: 'Email'),
      onSaved: (v) {
        _email = v;
      },
      validator: (s) {
        if (s.isEmpty)
          return 'required';
        else
          return null;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Password'),
      onSaved: (v) {
        _password = v;
      },
      validator: (v) {
        if (v.isEmpty)
          return 'required';
        else
          return null;
      },
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildEmail(),
          _buildPassword(),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return MaterialButton(
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
        child:
            model.isLoading == 1 ? CircularProgressIndicator() : Text('Login'),
      );
    });
  }

  Widget _buildSignUpButton() {
    return MaterialButton(
      onPressed: () => Navigator.of(context).pushNamed('/SignupPage'),
      child: Text('Sign Up'),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildLoginForm(),
        _buildLoginButton(),
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
