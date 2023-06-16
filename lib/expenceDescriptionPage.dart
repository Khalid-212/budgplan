import 'package:budgplan/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'models/data_model.dart';

class expenceDescriptionPage extends StatelessWidget {
  final Data? data;
  const expenceDescriptionPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var catagoryColor;
    if (data?.category == 'Transportation') {
      catagoryColor = Colors.amber;
    } else if (data?.category == 'Food') {
      catagoryColor = Color.fromARGB(255, 102, 204, 99);
    } else if (data?.category == 'Entertainment') {
      catagoryColor = Color.fromARGB(255, 163, 155, 93);
    } else if (data?.category == 'Shopping') {
      catagoryColor = Color.fromARGB(255, 1, 188, 208);
    } else if (data?.category == 'Bills') {
      catagoryColor = Color.fromARGB(255, 135, 80, 148);
    } else if (data?.category == 'Other') {
      catagoryColor = Color.fromARGB(255, 60, 53, 54);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(data!.category),
        backgroundColor: Color.fromARGB(43, 255, 255, 255),
        shadowColor: Color.fromARGB(43, 255, 255, 255),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          // alignment: Alignment.center,
          height: 400,
          width: MediaQuery.of(context).size.width - 1,
          child: Card(
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: catagoryColor!,
                  width: 2,
                )),
            // elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ETB ${data!.amount.toString()}",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 20),
                      Text(
                        "Date: ${data!.date}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Reason: ${data!.reason}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Category: ${data!.category}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.done,
                    color: catagoryColor,
                    size: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
