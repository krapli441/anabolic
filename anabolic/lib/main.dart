import 'package:flutter/cupertino.dart';

void main() {
  runApp(const CupertinoApp(
    home: MyCupertinoApp(),
  ));
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('ANABOLIC'), // 앱 바에 출력할 테스트
      ),
      child: Center(
        child: Text('Hello, World!'), // 가운데에 출력할 테스트
      ),
    );
  }
}
