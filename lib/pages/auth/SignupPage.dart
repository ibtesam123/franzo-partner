import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_model/MainModel.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  String _email, _name, _password;
  int _serviceID = 0;

  Widget _buildSignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'Email'),
            onSaved: (v) {
              _email = v;
            },
            validator: (v) {
              if (v.isEmpty)
                return 'required';
              else
                return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Name'),
            onSaved: (v) {
              _name = v;
            },
            validator: (v) {
              if (v.isEmpty)
                return 'required';
              else
                return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Password'),
            controller: _controller,
            onSaved: (v) {
              _password = v;
            },
            validator: (v) {
              if (v.isEmpty)
                return 'required';
              else
                return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Confirm Password'),
            validator: (v) {
              if (v.isEmpty)
                return 'required';
              else if (v != _controller.text)
                return 'password dont match';
              else
                return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubservice() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return DropdownButton<int>(
        onChanged: (v) {
          this.setState(() {
            _serviceID = v;
          });
        },
        value: _serviceID,
        items: model.services.map((s) {
          return DropdownMenuItem<int>(
            child: Text(s['serviceName']),
            value: s['id'],
          );
        }).toList(),
      );
    });
  }

  Widget _buildSignupButton() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return MaterialButton(
        onPressed: () async {
          if (model.isLoading == -1) {
            if (!_formKey.currentState.validate()) return;
            _formKey.currentState.save();

            var _res = await model.signupUser(
              name: _name,
              email: _email,
              password: _password,
              serviceID: _serviceID,
            );

            if (_res)
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/HomePage', (route) => false);
          }
        },
        child: model.isLoading == 2
            ? CircularProgressIndicator()
            : Text('Sign up'),
      );
    });
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildSignupForm(),
        _buildSubservice(),
        _buildSignupButton(),
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
