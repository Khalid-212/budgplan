import 'package:budgplan/Home.dart';
import 'package:budgplan/expenceDescriptionPage.dart';
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
    return Center(
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
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // make it not scrollable
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => expenceDescriptionPage(
                                data: snapshot.data![index],
                              ),
                            ),
                          ),
                          child: Dismissible(
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
                                margin: const EdgeInsets.all(8),
                                shadowColor: Color.fromARGB(95, 255, 193, 7),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        // category with its own circular avatar and amount
                                        CircleAvatar(
                                          backgroundColor: Colors.amber,
                                          child: Text(
                                            snapshot.data![index].category[0],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].amount
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data![index].date,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 40),
                                        // date with its own circular avatar and reason
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].category,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data![index].reason,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No Data Available'),
                  );
                }
              },
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
