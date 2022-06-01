import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/first_time_screen/first_time_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedTaskScreen()
  ];

  List<String> appBarTitle = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeIndex(index){

    currentIndex = index;
    emit(AppChangeBotNavBar());
  }


  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void databaseCreate() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async{
        // print('database created');
        try{
          await database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
          );
          // print('table created');
        }
        catch(error){
          // print('Error found ${error.toString()}');
        }
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        // print('database opened');
      },

    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });


  }



  Future <void> databaseInsert({
    required title,
    required date,
    required time,
  }) async {
    await database.transaction((txn) async {
      {
        txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")').then((value) {
          // print('$value added successfully');
          emit(AppInsertDatabaseState());

          getDataFromDatabase(database);
        });
      }
    });
  }

  void getDataFromDatabase(database) {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      // print(newTasks);

      value.forEach((element){
        if (element['status'] == 'new'){
          newTasks.add(element);
        }
        else if (element['status'] == 'done'){
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBotSheetState({
    required bool isShown,
    required IconData icon
}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;

    emit(AppChangeBotSheetState());
  }

  updateData ({
    required String statues,
    required int id
}) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [statues, id]).then((value) {

          getDataFromDatabase(database);

          emit(AppUpdateDatabaseState());
        });
  }

  delData ({
    required int id
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {

      getDataFromDatabase(database);

      emit(AppDelDatabaseState());
    });
  }
  void showIntroduction(context) async{
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('INTRODUCTION', true);
    Navigator.push(context, MaterialPageRoute(builder: ((context) => FirstTimeScreen())));
  }



}