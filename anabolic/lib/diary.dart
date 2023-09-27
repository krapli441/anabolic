// diary.dart

import 'package:flutter/material.dart';

class Diary extends StatelessWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('운동 기록'),
        ),
        body: const Center(
          child: Text('운동을 기록하는 페이지'),
        ));
  }
}
