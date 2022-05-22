import 'package:flutter/cupertino.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'New Tasks',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      ),
    );
  }
}
