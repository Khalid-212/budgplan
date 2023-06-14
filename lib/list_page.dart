import 'package:flutter/material.dart';
import 'package:budgplan/services/database.dart';
import 'package:budgplan/models/data_model.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
        backgroundColor: const Color.fromARGB(0, 244, 244, 244),
        shadowColor: const Color.fromARGB(0, 255, 193, 7),
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : FutureBuilder<List<Data>>(
                future: _dataList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          confirmDismiss: (_) =>
                              _showDeleteConfirmationDialog(context),
                          onDismissed: (direction) {
                            FinanceDataBase.instance
                                .delete(snapshot.data![index].id!);
                            setState(() {
                              snapshot.data!.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data Deleted'),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                snapshot.data![index].amount.toString(),
                              ),
                              subtitle: Text(
                                snapshot.data![index].category,
                              ),
                              trailing: Text(
                                snapshot.data![index].date,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No Data Available'),
                    );
                  }
                },
              ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Are you sure you want to delete this data?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
