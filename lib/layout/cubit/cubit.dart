import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = [
    const NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
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
  List<Map> tasks = [];
  void databaseCreate() {
    openDatabase(
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
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDatabaseState());
        });
        print('database opened');
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
          print('$value added successfully');
          emit(AppInsertDatabaseState());

          getDataFromDatabase(database).then((value) {
            tasks = value;
            print(tasks);
            emit(AppGetDatabaseState());
          });
        });
      }
    });
  }

  Future<List<Map>> getDataFromDatabase(database)async{
    emit(AppGetDatabaseLoadingState());

    return await database.rawQuery('SELECT * FROM tasks');
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


}