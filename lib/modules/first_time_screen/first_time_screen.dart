import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/layout/layout_screen.dart';
import 'package:todo_app/shared/components/components.dart';

class FirstTimeScreen extends StatelessWidget {
  FirstTimeScreen({Key? key}) : super(key: key);

  IconData addTask = Icons.edit;

  final List<PageViewModel> pages = [
    PageViewModel(
      title: 'Welcome',
      body: 'Before you start using the app, here\'s some introduction that will help you',
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 20.0,
        ),
      ),
    ),
    PageViewModel(
      title: 'Introduction',
      body: '''
      1. use the edit button to add a new task.
      
      2. use the check button to confirm that task is finished and move it directly into the finished tasks.
      
      3. use the archive button to archive tasks and move it directly into the archived tasks.
      
      4. use the X button if the task is not finished yet and you want to move the task back to the new task.
      
      5. swipe the task left or right to delete it.
      
      6. use the info in the top right button to see this introduction again.''',
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
      ),
        bodyTextStyle: TextStyle(
          fontSize: 20.0,
        ),
    ),
  )];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: (
        Text(
            'Todo App',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),)
        ),
      ),
      body: Padding(
       padding: const EdgeInsets.all(20.0),
       child: IntroductionScreen(
         pages: pages,
         dotsDecorator: const DotsDecorator(
           color: Colors.red,
           activeColor: Colors.blue,
           size: Size.square(15),
           activeSize: Size.square(20),
         ),
         showDoneButton: true,
         done: Container(
           child: const Center(
             child: Text('Done',
               style: TextStyle(
                 fontSize: 20,
                 color: Colors.white
               ),),
           ),
           width: 100,
           height: 50,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(25),
               color: Colors.green,
             )
         ),
         showSkipButton: false,
         skip: const Text('Skip',
           style: TextStyle(fontSize: 20),
         ),
         showBackButton: true,
         back: Container(
             child: const Icon(Icons.arrow_back, size: 25,
             color: Colors.white,),
             width: 70,
             height: 50,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(25),
               color: Colors.red,
             )
         ),
         showNextButton: true,
         next: Container(
           child: const Icon(Icons.arrow_forward,size: 25,
           color: Colors.white,),
             width: 70,
             height: 50,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(25),
               color: Colors.blue,
             )
         ),
         onDone: (){onDone(context);},
         curve: Curves.easeInBack,
       ),
     ),
    );
  }

  Future<void> onDone(context) async {
    // show = false;
    Navigator.push(context, MaterialPageRoute(builder: (context) => TodoApp()));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('INTRODUCTION', false);
  }
}
