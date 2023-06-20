import 'package:budgplan/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'models/data_model.dart';

class addBalancePage extends StatefulWidget {
  const addBalancePage({super.key});

  @override
  State<addBalancePage> createState() => _addBalancePageState();
}

class _addBalancePageState extends State<addBalancePage> {
  // responsible for saving data to the database
  int balance = 0;
  String name = '';
  int phonenumber = 0;
  Future addBalance() async {
    UserData userData = UserData(
      name: name,
      phonenumber: phonenumber,
      balance: balance,
    );

    await UserDatabase.instance.create(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Balance'),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            const Text('Add Balance'),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  name = value.toString();
                }),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Name',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  phonenumber = int.parse(value);
                }),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Phone Number',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  balance = int.tryParse(value.toString()) ?? balance;
                }),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Balance',
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 249, 187, 2)),
              ),
              onPressed: () {
                addBalance();
                Navigator.pop(context);
              },
              child: Text(
                'Add balance',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
