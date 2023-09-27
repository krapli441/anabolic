// main.dart
// package
import 'package:flutter/material.dart';

// components
import 'diary.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // const 키워드를 제거했습니다.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const Scaffold(
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ANABOLIC',
                style: TextStyle(color: Colors.black, fontSize: 32),
              ),
              NavigateButton(),
            ],
          )),
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ));
  }
}

class NavigateButton extends StatelessWidget {
  const NavigateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Diary()));
        },
        child: const Text('운동 기록'));
  }
}
