import 'package:flutter/material.dart';
// Flutter 프레임워크의 material 디자인 위젯을 사용하기 위해 필요한 패키지를 import 하였음.

// 앱의 진입점 (Entry Point), 앱을 실행할 때 처음 호출되는 함수이다.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const Scaffold(
          body: Center(
            child: Text(
              'Hello, World!',
              style: TextStyle(color: Colors.white),
            ), // 가운데에 출력할 텍스트
          ),
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ));
  }
}
