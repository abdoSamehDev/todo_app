import 'package:bloc/bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/shared/components/constants.dart';

Widget defaultButton(
        {double width = double.infinity,
        Color backgroundColor = Colors.blue,
        double radius = 10,
        required void Function()? function,
        required String text,
        double fontSize = 25,
        Color fontColor = Colors.white}) =>
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), color: backgroundColor),
      width: width,
      // color: Colors.lightBlue,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: fontSize, color: fontColor),
        ),
      ),
    );

Widget defaultTextFormField(
        {bool isPassword = false,
        required String label,
        required TextInputType type,
        required TextEditingController controller,
        void Function(String)? onSubmitted,
        required String validateReturn,
        required IconData prefix,
        IconData? suffix,
        void Function()? suffixButtonFunction,
        void Function()? onTapFunction,
        bool border = true}) =>
    TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return validateReturn;
        }
        return null;
      },
      controller: controller,
      onFieldSubmitted: onSubmitted,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isPassword,
      onTap: onTapFunction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixButtonFunction,
              )
            : null,
        border: border != true ? null : const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 25,

                      // color: Colors.white,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(statues: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(statues: 'archived', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.orange,
                )),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(statues: 'new', id: model['id']);
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
  onDismissed: (direction){
    AppCubit.get(context).delData(id: model['id']);
  },
    );

Widget tasksBuilder (List<Map> tasks, String msg) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context) => ListView.separated(itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
      separatorBuilder: (context, index) => Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[400],
      ),
      itemCount: tasks.length),
  fallback: (context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu,
            color: Colors.grey,
            size: 100,
          ),
          Text(
            '$msg',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 25,
                color: Colors.grey,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    ),
  ),
);

bool show = true;
