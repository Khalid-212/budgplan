import 'package:budgplan/Home.dart';
import 'package:budgplan/View.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
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
  const ViewData(),
];

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
            });
          },
        ));
  }
}
