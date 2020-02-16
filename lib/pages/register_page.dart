import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: Form(
        key: _registerFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name', hintText: "John Jackson"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter name.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email', hintText: "johnjackson@example.com"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter email';
                  } else if (!EmailValidator.validate(value)) {
                    // Use plugin https://pub.dev/packages/email_validator
                    // If you don't want to use plugin https://stackoverflow.com/questions/16800540/validate-email-address-in-dart
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  // This is not correct validation. Later we will improve this validation.
                  if (value.isEmpty) {
                    return 'Confirm Password is not matching';
                  }
                  return null;
                },
              ),
              Container(
                // https://stackoverflow.com/questions/50186555/how-to-set-margin-for-a-button-in-flutter
                margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: RaisedButton(
                  child: Text("Register"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_registerFormKey.currentState.validate()) {
                      print('Validation Ok! Submit!');
                    }
                  },
                ),
              ),
              Text("Already have an account?"),
              FlatButton(
                child: Text("Login here!"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
}