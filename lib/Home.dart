import 'dart:math';

import 'package:budgplan/addBalancePage.dart';
import 'package:budgplan/models/data_model.dart';
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

var userBalance;

// get balance from the database
Future getBalance() async {
  final balance = await UserDatabase.instance.readUserAllData();
  print('balance');
  print(balance);
  userBalance = balance as String;
}

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

  // get data from the database
  Future getData() async {
    final dataList = await UserDatabase.instance.readUserAllData();
    print(dataList);
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
              children: <Widget>[
                Image(image: AssetImage('assets/saving1.png')),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Column(
                //       children: [
                //         GestureDetector(
                //           onTap: () => getBalance(),
                //           child: Text(
                //             'Balance  ${userBalance == null ? '****' : userBalance[0]['balance'].toString()}',
                //             style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //                 backgroundColor: Colors.amber),
                //           ),
                //         ),
                //       ],
                //     ),
                //     FloatingActionButton(
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => addBalancePage(),
                //           ),
                //         );
                //       },
                //       child: const Icon(Icons.add),
                //       backgroundColor: const Color.fromARGB(255, 249, 187, 2),
                //       mini: true,
                //       tooltip: 'Add Balance',
                //     ),
                //   ],
                // ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'data added successfully',
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.amber,
                        ),
                      );
                    }
                    addData();
                  },
                  child: const Text('Submit'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 249, 187, 2)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
