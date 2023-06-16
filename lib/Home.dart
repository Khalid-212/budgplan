import 'dart:math';

import 'package:budgplan/models/data_model.dart';
import 'package:budgplan/services/DatabaseSyncService.dart';
import 'package:budgplan/services/database.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class homePage extends StatefulWidget {
  final Data? data;

  homePage({Key? key, this.data}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

String category = '';
String selectedType = 'Expense';
int amount = 0;
String reason = '';
var now = DateTime.now();
String date = now.toString();

class _homePageState extends State<homePage> {
  final _formKey = GlobalKey<FormState>();

  List categories = [
    'Transportation',
    'Food',
    'Entertainment',
    'Shopping',
    'Bills',
    'Other',
  ];

  // responsible for saving data to the database
  Future addData() async {
    Data data = Data(
      amount: amount,
      category: category,
      date: date,
      reason: reason,
    );

    await FinanceDataBase.instance.create(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 244, 244, 244),
        shadowColor: const Color.fromARGB(0, 255, 193, 7),
        foregroundColor: Colors.black,
        title: const Text('BudgPlanner'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Image(image: AssetImage('assets/saving1.png')),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      amount = int.tryParse(value.toString()) ?? amount;
                    }),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Amount',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      reason = value.toString();
                    }),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter reason',
                    ),
                  ),
                ),
                SizedBox(
                  width: 340, // <-- TextField width
                  height: 120, //
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Category',
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text('$category'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        category = val.toString();
                      });
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'data added successfully',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      addData();
                    },
                    child: const Text('Submit'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 249, 187, 2)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
