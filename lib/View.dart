import 'package:budgplan/PieChartPage.dart';
import 'package:flutter/material.dart';
import 'package:budgplan/services/database.dart';
import 'package:budgplan/models/data_model.dart';
import 'list_page.dart';

class viewData extends StatefulWidget {
  const viewData({Key? key}) : super(key: key);

  @override
  State<viewData> createState() => _viewDataState();
}

class _viewDataState extends State<viewData> {
  late Future<List<Data>> _dataList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    setState(() => _isLoading = true);

    _dataList = FinanceDataBase.instance.readAllData();

    _dataList.whenComplete(() => setState(() => _isLoading = false));
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
                : FutureBuilder<List<Data>>(
                    future: _dataList,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<Data> dataList = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: PieChartPage(dataList: dataList),
                          ),
                          const Expanded(
                            child: ListPage(),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: viewData(),
  ));
}
