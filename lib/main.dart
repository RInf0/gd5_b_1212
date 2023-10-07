import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd5_b_1212/database/sql_helper.dart';
import 'package:gd5_b_1212/entity/employee.dart';
import 'package:gd5_b_1212/inputPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(
        title: 'SQFLITE',
      ),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> employee = [];
  void refresh() async {
    final data = await SQLHelper.getEmployee();
    setState(() {
      employee = data;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("EMPLOYEE"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const InputPage(
                    title: "INPUT EMPLOYEE", 
                    id: null, 
                    name: null, 
                    email: null,
                    address: null)),
              ).then((_) => refresh());
            }),
          IconButton(icon: Icon(Icons.clear), onPressed: () async {})
        ],
      ),
      body: ListView.builder(
        itemCount: employee.length,
        itemBuilder: (context, index) {
          return Slidable(
            child: ListTile(
              title: Text(employee[index]['name']),
              subtitle: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(employee[index]['email']),
                  Text(employee[index]['address']),
                ],
              )
            ), 
            actionPane: SlidableBehindActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: 'Update',
                color: Colors.blue,
                icon: Icons.update,
                onTap: () async {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => InputPage(
                        title: 'INPUT EMPLOYEE', 
                        id: employee[index]['id'], 
                        name: employee[index]['name'], 
                        email: employee[index]['email'],
                        address: employee[index]['address'])),
                  ).then((_) => refresh());
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  await deleteEmployee(employee[index]['id']);
                },
              )
            ]
          );
        }));
  }

  Future<void> deleteEmployee(int id) async {
    await SQLHelper.deleteEmployee(id);
    refresh();
  }
}