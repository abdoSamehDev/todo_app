import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';


class TodoApp extends StatelessWidget {
  TodoApp({Key? key}) : super(key: key);


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  late TimeOfDay? time;
  late DateTime? date;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..databaseCreate(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) Navigator.pop(context);

        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () async {
                    cubit.showIntroduction(context);
                  },
                  icon: const Icon(Icons.info_outline_rounded))
            ],
            title: Text(
              cubit.appBarTitle[cubit.currentIndex],
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
              if(cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()){
                  cubit.databaseInsert(title: titleController.text, date: dateController.text, time: timeController.text).then((value) {
                    titleController.clear();
                    dateController.clear();
                    timeController.clear();
                  },

                  );
                //   await databaseInsert(
                //       title: titleController,
                //       date: date,
                //       time: time
                //   );
                //   Navigator.pop(context);
                //   isBottomSheetShown = false;
                //   // setState(() {
                //   //   fabIcon = Icons.edit;
                //   // });
                //   // print(titleController.text);
                //   // print({DateFormat.yMEd().format(date!)});
                //   // print(time!.format(context));
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
                  cubit.changeBotSheetState(isShown: false, icon: Icons.edit);
                });
                cubit.changeBotSheetState(isShown: true, icon: Icons.add);
              }

            },
            child: Icon(cubit.fabIcon),
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
            currentIndex: cubit.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index){
              cubit.changeIndex(index);
            },
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDatabaseLoadingState,
            builder: (context) => cubit.screen [cubit.currentIndex],
            fallback: (context) => const Center(child: const CircularProgressIndicator()),
          ),

        );
        },
      ),
      );

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


