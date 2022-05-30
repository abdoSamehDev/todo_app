import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/constants.dart';
Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  double radius = 10,
  required void Function()? function,
  required String text,
  double fontSize = 25,
  Color fontColor = Colors.white
}
    ) => Container(
  decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: backgroundColor
  ),
  width: width,
  // color: Colors.lightBlue,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
          fontSize: fontSize,
          color: fontColor

      ),
    ),
  ),
);

Widget defaultTextFormField({
  bool isPassword = false,
  required String label,
  required TextInputType type,
  required TextEditingController controller,
  void Function(String)? onSubmitted,
  required String validateReturn,
  required IconData prefix,
  IconData? suffix,
  void Function()? suffixButtonFunction,
  void Function()? onTapFunction,
  bool border = true

}) => TextFormField(
  validator: (value)
  {
    if(value!.isEmpty)
    {
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
    suffixIcon: suffix != null ? IconButton(icon: Icon(suffix),
      onPressed: suffixButtonFunction,
    ) : null,
    border: border != true ? null : const OutlineInputBorder(),
  ),
);

Widget buildTaskItem(Map model) => Padding(
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
        Column(
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
            Text(
              '${model['date']}',
              style: const TextStyle(
                  color: Colors.grey
              ),
            ),
          ],
        ),
      ],
    ),
  );