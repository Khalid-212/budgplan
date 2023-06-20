import 'package:budgplan/main.dart';
import 'package:budgplan/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/data_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var balance = 0;
  var name = '';
  var phonenumber = 0;

//  add user data to the userdatabase
  Future addUserData() async {
    UserData userdata = UserData(
      balance: balance,
      name: name,
      phonenumber: phonenumber,
    );

    await UserDatabase.instance.create(userdata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  balance = int.parse(value);
                }),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Name',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  name = value.toString();
                }),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Phone Number',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addUserData();
                },
                child: Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
