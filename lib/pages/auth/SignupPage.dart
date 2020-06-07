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
  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'EMAIL',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Please enter a valid email';
          } else
            return null;
        },
        onSaved: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'FULL NAME',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Invalid Name';
          } else
            return null;
        },
        onSaved: (value) {
          _name = value;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'PASSWORD',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password cannot be empty';
          } else
            return null;
        },
        onSaved: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'CONFIRM PASSWORD',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password cannot be empty';
          } else if (value != _controller.text) {
            return 'Password not same';
          } else
            return null;
        },
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildEmailField(),
          _buildNameField(),
          _buildPasswordField(),
          _buildConfirmPasswordField(),
        ],
      ),
    );
  }

  Widget _buildSubservice() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: DropdownButton<int>(
          onChanged: (v) {
            this.setState(() {
              _serviceID = v;
            });
          },
          value: _serviceID,
          isDense: true,
          underline: Container(),
          items: model.services.map((s) {
            return DropdownMenuItem<int>(
              child: Text(
                s['serviceName'],
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              value: s['id'],
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildSignupButton() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Padding(
        padding: EdgeInsets.only(top: 20),
        child: MaterialButton(
          height: 40,
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.black,
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
              : Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      );
    });
  }

  Widget _buildBackButton() {
    return Padding(
        padding: EdgeInsets.only(top: 15),
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
              Navigator.of(context).pop();
            },
            child: Text(
              'Back',
              style: TextStyle(),
            ),
          ),
        ));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 150,
            ),
            child: Text(
              'SignUp Merchant.',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSignupForm(),
          _buildSubservice(),
          _buildSignupButton(),
          _buildBackButton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
