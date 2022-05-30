import 'package:flutter/cupertino.dart';

class DoneTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
          'Done Tasks',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      ),
    );
  }
}
