import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 앱의 루트 위젯을 구성하는 빌드 메서드
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 이 부분에서 앱의 테마를 지정할 수 있다.
        //
        // "flutter run"을 사용하여 앱을 실행하면 앱에 파란색 툴바가 표시될 것이다.
        // 이 상태에서 앱을 종료하지 않고, 아래의 colorScheme에서 seedColor를 Colors.green으로 변경하고
        // "hot reload"를 실행하면 앱의 테마가 변경된 것을 확인할 수 있다.
        //
        // 주목할 점은 hot reload를 해도 카운터가 다시 0으로 재설정되지 않았다는 것이다.
        // 앱의 상태는 리로드 중에 손실되지 않는다. 상태를 재설정하려면 hot restart를 사용해야 함.
        //
        // 이 작업은 값뿐만 아니라 코드에도 적용됨. 대부분의 코드 변경은 hot reload로 테스트할 수 있다.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Anabolic'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // 이 위젯은 앱의 홈 페이지다.
  // 이것은 상태를 가지며, 이 상태에는 아래에 정의된 필드가 있어서 화면이 어떻게 보이는지에 영향을 미친다.
  // 이 클래스는 상태를 구성할 수 있다. 이 클래스는 부모(이 경우 App 위젯)에서
  // 제공하는 값들(이 경우 제목)을 보유하고 있으며, 이 값들은 State의 build 메서드에서 사용된다.

  // 위젯 하위 클래스의 필드는 항상 "final"로 표시된다.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // setState 메서드를 호출하는 것으로, Flutter 프레임워크에게 이 State에서 무엇인가 변경되었음을 알린다.
      // 이로 인해 아래의 build 메서드를 다시 실행하게 되며, 화면이 업데이트된 값을 반영한다.
      // 만약 setState()를 호출하지 않고 _counter를 변경한다면 build 메서드가 다시 호출되지 않으므로
      // 아무런 변화가 일어나지 않을 것이다.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 이 메서드는 setState가 호출될 때마다 다시 실행된다. 예를 들면 위에서 설명한 _incrementCounter 메서드에서 호출됨.
    //
    // Flutter 프레임워크는 build 메서드를 다시 실행하는 것을 최적화하여, 업데이트가 필요한 모든 것을 다시 빠르게 구축한다.
    // 그래서 위젯의 인스턴스를 개별적으로 변경하는 대신 업데이트가 필요한 모든 부분을 재구성할 수 있다.
    return Scaffold(
      appBar: AppBar(
        // 이 부분의 색상을 특정 색상으로 변경해보세자 (예를 들어 Colors.amber 등).
        // 그런 다음 AppBar의 색상이 변경되는 것을 확인하고 다른 색상은 그대로 유지됩니다.
        backgroundColor: Colors.blue,
        // 여기서는 App.build 메서드에서 생성된 MyHomePage 객체에서 값을 가져와서 App Bar의 제목을 설정합니다.
        title: Text(widget.title),
      ),
      body: Center(
        // Center는 레이아웃 위젯입니다. 하나의 자식을 가져와서 부모의 중앙에 배치합니다.
        child: Column(
          // Column 또한 레이아웃 위젯으로, 자식들의 목록을 가져와 수직으로 정렬합니다. 기본적으로 자식들을 수평으로 맞추고 부모의 높이에 맞추려고 합니다.
          //
          // Column은 자신을 크기를 조절하고 자식들을 어떻게 배치할지 제어하는 다양한 속성이 있습니다.
          // 여기서는 mainAxisAlignment을 사용하여 자식들을 수직으로 중앙에 배치합니다. 여기서 주축은 수직축이며 Column은 수직으로 정렬됩니다
          // (수평축은 가로입니다).
          //
          // TRY THIS: "debug painting"을 활성화하여 (IDE에서 "Toggle Debug Paint" 액션을 선택하거나 콘솔에서 "p"를 누름) 각 위젯의 와이어프레임을 확인해보세요.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // 이 후행 쉼표는 build 메서드에 대한 자동 형식 지원을 더 잘 보이게 만듭니다.
    );
  }
}
