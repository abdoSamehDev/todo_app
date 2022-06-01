import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/layout/layout_screen.dart';
import 'package:todo_app/modules/first_time_screen/first_time_screen.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'shared/components/components.dart';


// bool show = true;
void main() async {
  BlocOverrides.runZoned(
        () async {
          WidgetsFlutterBinding.ensureInitialized();
          final prefs = await SharedPreferences.getInstance();
          show = prefs.getBool('INTRODUCTION') ?? true;
          runApp(const MyApp());
          },
    blocObserver: MyBlocObserver(),
  );
  // WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // show = prefs.getBool('INTRODUCTION') ?? true;
  // runApp(MyApp());

}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  // MyApp({required show});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/images/app-logo.png',
                scale: 8,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Todo App',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              // SizedBox(
              //   height: 100,
              // ),
              const Spacer(),
              Image.asset('assets/images/logo.png',
                width: 55,
                height: 55,
              ),
            ],
          ),
        ),
        nextScreen: show ? FirstTimeScreen() : TodoApp(),
        backgroundColor: Colors.blue,
        animationDuration: const Duration(seconds: 1),
        // splashTransition: SplashTransition.,
        // centered: true,
        pageTransitionType: PageTransitionType.fade,
        duration: 2000,
        splashIconSize: double.infinity,
      ),
    );
  }
}

