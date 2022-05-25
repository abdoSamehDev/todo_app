import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';

import '../shared/components/constants.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  int currentIndex = 1;
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  late TimeOfDay? time;
  late DateTime? date;

  List<Widget> screen = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];

  List<String> appBarTitle = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseCreate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          appBarTitle[currentIndex],
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            if(isBottomSheetShown) {
              if (formKey.currentState!.validate()){
                await databaseInsert(
                  title: titleController,
                  date: date,
                  time: time
                );
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
                print(titleController.text);
                print(DateFormat.yMMMd().format(date!));
                print(time!.format(context));
              }
            }
          else{
            scaffoldKey.currentState!.showBottomSheet((context) {
              return Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultTextFormField(
                        label: 'Task Title',
                        type: TextInputType.text,
                        controller: titleController,
                        validateReturn: 'Title Can\'t be empty',
                        prefix: Icons.title),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                        label: 'Task Date',
                        type: TextInputType.datetime,
                        controller: dateController,
                        validateReturn: 'Date Can\'t be empty',
                        prefix: Icons.calendar_today_rounded,
                        onTapFunction: () async {
                          date = await showDatePicker(context: context, firstDate: DateTime.now(), initialDate: DateTime.now(), lastDate: DateTime.parse('2025-12-31'));
                          print(DateFormat.yMMMd().format(date!));
                          dateController.text = DateFormat.yMEd().format(date!);
                        }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                          label: 'Task Time',
                          type: TextInputType.datetime,
                          controller: timeController,
                          validateReturn: 'Time Can\'t be empty',
                          prefix: Icons.watch_later_outlined,
                          onTapFunction: () async {
                            time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                            print(time!.format(context));
                            timeController.text = time!.format(context).toString();
                          }
                      ),
                    ],
                  ),
                ),
              );
            },
              elevation: 20,
            ).closed.then((value){
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }

        },
      child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
      body: ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) => screen [currentIndex],
        fallback: (context) => Center(child: CircularProgressIndicator()),
      ),

    );
  }

  void databaseCreate() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async{
        print('database created');
        try{
        await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        );
        print('table created');}
        catch(error){
            print('Error found ${error.toString()}');
        }
      },
      onOpen: (database) async{
        tasks = await getDataFromDatabase(database);
          print(tasks);
        print('database opened');
      },

    );

  }



  Future <void> databaseInsert({
    required title,
    required date,
    required time,
}) async {
    await database.transaction((txn) async {
      try{
      int id = await txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("${title.text}", "${DateFormat.yMEd().format(date!)}", "${time!.format(context).toString()}", "new")');
      print('$id added successfully');
      }
      catch(error){
        print('Error Found ${error.toString()}');
      }
    });
  }

  Future<List<Map>> getDataFromDatabase(database)async{
    return await database.rawQuery('SELECT * FROM tasks');
  }


  // Future<void> databaseInsert() async {
  //   database.transaction((txn) async {
  //           txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("go to gym", "20/5/2022", "10 AM", "new")').then((value) {
  //             print('${value.toString()} added successfully');
  //           }).catchError((error){
  //             print('Error Found ${error.toString()}');
  //           });
  //   });
  // }
}
