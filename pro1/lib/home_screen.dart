// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'modules/arcive_screen.dart';
import 'modules/done_screen.dart';
import 'modules/task_screen.dart';
import 'package:http/http.dart' as http;
class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {

  List<String> titel = ['Task_Screen', ' Done_Screen', 'Archived_Screen'];
  List<Widget> screen = [
    Task_Screen(),
     Done_Screen(),
     Archived_Screen(),
  ];
  late Database data1;
  int index1 = 0;
  var scafulled = GlobalKey<ScaffoldState>();
  late bool isChangeBottomSheet = false;
  IconData icon = Icons.edit;
  var titleTask = TextEditingController();
  var dateTask = TextEditingController();
  var timeTask = TextEditingController();
  var statusTask = TextEditingController();

  @override
  void initState() {
    createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafulled,
      appBar: AppBar(
        title: Text(
          titel[index1],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isChangeBottomSheet) {
              Navigator.pop(context);
              isChangeBottomSheet = false;
              icon = Icons.edit;
            } else {
              scafulled.currentState?.showBottomSheet(
                    (context) =>
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white24,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Name Task',
                                prefixIcon: Icon(Icons.add_comment_sharp),
                              ),
                              onChanged: (value) {},
                              controller: titleTask,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Date Task',
                                prefixIcon: Icon(Icons.add_alarm_sharp),
                              ),
                              onChanged: (value) {},
                              controller: dateTask,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Time Task',
                                prefixIcon: Icon(Icons.add_alert_sharp),
                              ),
                              onChanged: (value) {},
                              controller: timeTask,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Status Task',
                                prefixIcon: Icon(Icons.done_outline),
                              ),
                              onChanged: (value) {},
                              controller: statusTask,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextButton(
                                onPressed: () {
                                  insertToDatabase();
                                },
                                child: const Center(
                                  child: Text(
                                    'Send Data ',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        backgroundColor: Colors.white24),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
              );
              isChangeBottomSheet = true;
              icon = Icons.add;
            }
          });

          // insertToDatabase();
        },
        child: Icon(icon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index1,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            index1 = index;
          });
        },
        elevation: 15,
        backgroundColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Tasks',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archive',
          ),
        ],
      ),
      body: screen[index1],
    );
  }

  void createDatabase() async {
    data1 = await openDatabase("app.db", version: 1,
        onCreate: (Database data, version) {
          print('database created');
          data
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT , date TEXT ,time TEXT , status TEXT )')
              .then((value) {
            print('create table');
          }).catchError((error) async {
            print('Error with create table${error.toString()}');
          });
        }, onOpen: (data1) {
          print('open database');
        });
  }

  void insertToDatabase() {
    data1.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES ("$titleTask","$dateTask","$timeTask","$statusTask")')
          .then((value) {
        print('$value successfully');
      }).catchError((error) {
        print('$error error witn insert');
      });
      return data1.getVersion();
    });
  }


}