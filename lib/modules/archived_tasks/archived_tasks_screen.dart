import 'package:flutter/cupertino.dart';

class ArchivedTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'Archived Tasks',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      ),
    );
  }
}
