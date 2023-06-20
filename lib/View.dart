import 'dart:ffi';

import 'package:budgplan/PieChartPage.dart';
import 'package:flutter/material.dart';
import 'package:budgplan/services/database.dart';
import 'package:budgplan/models/data_model.dart';

import 'list_page.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key}) : super(key: key);

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  late Future<List<Data>> _dataList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    setState(() => _isLoading = true);

    try {
      _dataList = FinanceDataBase.instance.readAllData();
      await _dataList;
    } catch (error) {
      // Handle error gracefully, e.g., show an error message
      print('Error fetching data: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // add data to userDatabase
  var balance;
  var name;
  var phonenumber;
  Future<void> addData() async {
    UserData userData =
        UserData(balance: balance, name: name, phonenumber: phonenumber);

    await UserDatabase.instance.create(userData);
    print('data added');
  }

  // get data from userDatabase
  Future<void> getUserData() async {
    final userData = await UserDatabase.instance.readUserAllData();
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        foregroundColor: Colors.black,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        shadowColor: Color.fromARGB(0, 255, 255, 255),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<Data>>(
                        future: _dataList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text('No data available'),
                            );
                          }
                          List<Data> dataList = snapshot.data!;
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: PieChartPage(dataList: dataList),
                                ),
                                ListPage()
                              ],
                            ),
                          );
                        }),
                  ),
          ),
        ),
      ),
    );
  }
}
