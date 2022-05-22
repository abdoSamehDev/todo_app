import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  int currentIndex = 1;

  List<Widget> screen = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];

  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title[currentIndex],
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // try{
          //   throw('404 Not Found');
          //   var name = await namePrint();
          //   print(name);
          //   throw('404 Not Found');
          // }
          // catch(error){
          //   print('Error ${error.toString()}');
          // }
          namePrint().then((value) {
            print(value);
            print('Ali');
            throw('404 Not Found');
          }).catchError((error){
            print('Error ${error.toString()}');
          });

        },
      child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
         BottomNavigationBarItem(
             icon: Icon(Icons.menu),
         label: 'New Tasks'
         ),
         BottomNavigationBarItem(
             icon: Icon(Icons.check_circle),
         label: 'Done'
         ),
         BottomNavigationBarItem(
             icon: Icon(Icons.archive),
         label: 'Archived'
         ),
        ],
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: screen [currentIndex],

    );
  }

  Future<String> namePrint() async {
    return 'Abdo Sameh';
  }
}
