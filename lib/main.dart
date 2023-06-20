import 'package:budgplan/Home.dart';
import 'package:budgplan/LoginPage.dart';
import 'package:budgplan/View.dart';
import 'package:budgplan/googleSignInPage.dart';
import 'package:budgplan/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> syncData() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    final localDatabasePath = await getDatabasesPath();
    final localDatabase = await openDatabase('$localDatabasePath/finance.db');
    final firebaseCollection =
        FirebaseFirestore.instance.collection('FinancedData');

    final records = await localDatabase.rawQuery('SELECT * FROM financeData');

    for (var record in records) {
      final existingData = await firebaseCollection
          .where('_id', isEqualTo: record['_id'])
          .limit(1)
          .get();

      if (existingData.docs.isEmpty) {
        await firebaseCollection.add(record);
      }
    }
  }
}

Future removeAllRecords() async {
  final localDatabasePath = await getDatabasesPath();
  final localDatabase = await openDatabase('$localDatabasePath/finance.db');
  await localDatabase.rawQuery('DELETE FROM financeData');
  // remove all the data from the firebase
  var firebaseCollection = FirebaseFirestore.instance.collection('FinanceData');
  var firebaseData = await firebaseCollection.get();
  var firebaseDataList = firebaseData.docs;
  var firebaseDataListLength = firebaseDataList.length;
  for (var i = 0; i < firebaseDataListLength; i++) {
    await firebaseCollection.doc(firebaseDataList[i].id).delete();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudgPlanner',
      theme: ThemeData(),
      home: const MyHomePage(title: 'BudgPlanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var currentindex = 0;
var pages = [
  homePage(),
  ViewData(),
];
var firsttime = true;
var onboarding = false;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentindex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_outlined),
              label: 'View',
            ),
          ],
          currentIndex: currentindex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            setState(() {
              currentindex = index;
              if (index == 1) {
                syncData();
              } else {
                // removeAllRecords();
              }
            });
          },
        ));
  }
}
